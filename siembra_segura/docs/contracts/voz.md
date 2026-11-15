# Contrato: voz de Semi (propuesta del front, decisión B8)

La app lee en voz alta cada pantalla ("Escuchar" y los mensajes de Semi).
Parte del texto es fijo y parte cambia con el clima, la parcela y el día, así
que el audio se genera **a pedido** en el backend. La app nunca guarda claves
de servicios de voz.

## Endpoint

```
POST {API_BASE_URL}/v1/speech
Content-Type: application/json
Accept: audio/mpeg
```

### Cuerpo

```json
{ "text": "Viene lluvia fuerte el jueves. No abones ese día.", "language": "es-PE" }
```

| Campo | Tipo | Notas |
|---|---|---|
| `text` | string | Ya viene en palabras: la app cambia `S/ 5,000` por `5,000 soles`, `°C` por `grados`, etc. Máximo recomendado: 600 caracteres |
| `language` | string | Siempre `es-PE` por ahora |

### Respuestas

| Código | Cuerpo | Qué hace la app |
|---|---|---|
| `200` | MP3 (`Content-Type: audio/mpeg`) | Lo reproduce y lo guarda en el celular |
| `4xx` / `5xx` | Texto con el motivo | Lee la frase con la voz del celular |
| Más de 15 s sin respuesta | — | Lee la frase con la voz del celular |

## Qué se espera del backend

- **Caché por texto.** El mensaje del clima es por valle y por día, no por
  persona: muchos agricultores piden la misma frase. Guardar el MP3 con
  clave `hash(voz + texto)` y servirlo de ahí reduce el costo casi a cero.
- **Sin autenticación por ahora** (igual que el resto, B1). Si se agrega,
  conviene un límite de pedidos por IP para que nadie gaste la cuota del
  motor de voz.
- **Si cambian de voz**, publiquen la nueva en `v2/speech` o avisen al
  front: la app guarda los audios por URL y no sabría que cambió.

## Motores de voz gratuitos o con plan gratis

| Motor | Ventaja | A tener en cuenta |
|---|---|---|
| **Azure Speech** (plan F0) | Voces peruanas: `es-PE-CamilaNeural`, `es-PE-AlexNeural` | Requiere cuenta de Azure; revisar el límite mensual vigente |
| **Google Cloud TTS** | Voces Neural2 en `es-US` muy naturales | Pide tarjeta para el plan gratis |
| **Piper** / **Kokoro** | Código abierto, corren en el propio servidor, sin cuotas | Revisar la licencia de cada voz; algo menos natural |

## Ejemplo mínimo (FastAPI + Azure)

```python
import os

import httpx
from fastapi import APIRouter, HTTPException
from fastapi.responses import Response
from pydantic import BaseModel, Field

router = APIRouter()
_cache: dict[str, bytes] = {}  # en producción: disco o Redis

AZURE_KEY = os.environ["AZURE_SPEECH_KEY"]
AZURE_REGION = os.environ.get("AZURE_SPEECH_REGION", "eastus")
VOICE = "es-PE-CamilaNeural"


class SpeechRequest(BaseModel):
    text: str = Field(min_length=1, max_length=600)
    language: str = "es-PE"


@router.post("/v1/speech")
async def speech(req: SpeechRequest) -> Response:
    key = f"{VOICE}\n{req.text}"
    if key not in _cache:
        text = (req.text.replace("&", "&amp;")
                .replace("<", "&lt;").replace(">", "&gt;"))
        # Un poco más lento y cálido para el campo.
        ssml = (
            f'<speak version="1.0" xml:lang="es-PE">'
            f'<voice name="{VOICE}"><prosody rate="-8%" pitch="+4%">'
            f"{text}</prosody></voice></speak>"
        )
        async with httpx.AsyncClient(timeout=12) as client:
            r = await client.post(
                f"https://{AZURE_REGION}.tts.speech.microsoft.com/cognitiveservices/v1",
                headers={
                    "Ocp-Apim-Subscription-Key": AZURE_KEY,
                    "Content-Type": "application/ssml+xml",
                    "X-Microsoft-OutputFormat": "audio-24khz-48kbitrate-mono-mp3",
                },
                content=ssml.encode("utf-8"),
            )
        if r.status_code != 200:
            raise HTTPException(502, f"Motor de voz: {r.status_code}")
        _cache[key] = r.content
    return Response(_cache[key], media_type="audio/mpeg")
```

## Probarlo con la app

En `config/dev.json`:

```json
{
  "APP_ENV": "dev",
  "DATA_SOURCE": "mock",
  "API_BASE_URL": "http://10.0.2.2:8000",
  "VOICE_SOURCE": "backend"
}
```

`10.0.2.2` es la PC vista desde el emulador de Android. En un celular real,
usen la IP de la PC en la red wifi (p. ej. `http://192.168.1.20:8000`). Los
datos siguen siendo de ejemplo: solo la voz sale del backend.

> En Android, `http://` (sin `s`) solo está permitido en builds de debug
> (`android/app/src/debug/AndroidManifest.xml`); en producción, `https://`.
