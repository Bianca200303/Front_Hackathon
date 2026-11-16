/// Traducciones de los textos de ejemplo (ver `MockText`), con el texto en
/// español como clave. Una prueba comprueba que no falte ninguno en inglés.
const mockTextsEn = <String, String>{
  // Catálogo.
  'Arroz': 'Rice',
  'Maíz': 'Maize',
  'Frejol': 'Beans',
  'Algodón': 'Cotton',
  'Menestra': 'Pulses',
  'Otro': 'Other',
  'Abono verde': 'Green manure',
  'Que el clima no malogre mi cosecha':
      'Keep the weather from ruining my harvest',
  'que el clima no malogre tu cosecha':
      'keeping the weather from ruining your harvest',
  'Cuidar mi agua': 'Save my water',
  'cuidar tu agua': 'saving your water',
  'Recuperar mi tierra': 'Restore my soil',
  'recuperar tu tierra': 'restoring your soil',
  'No tengo comprador para algodón': 'I have no buyer for cotton',
  'Tendré poca agua': "I'll have little water",

  // Planificación.
  'Con El Niño llueve más; ': 'With El Niño it rains more; ',
  'En un año normal, ': 'In a normal year, ',
  'En un año seco, ': 'In a dry year, ',
  'Lleva 3 campañas seguidas de arroz.':
      'It has had 3 seasons of rice in a row.',
  'Tiene poca materia orgánica.': 'It has little organic matter.',
  'Es lo que siembras hoy. Lo comparamos para que veas la diferencia.':
      "It's what you plant today. We compare it so you can see the "
      'difference.',
  'Depende de cuánta agua tenga Poechos este año.':
      'It depends on how much water Poechos has this year.',
  'usa la mitad que el arroz': 'uses half as much as rice',
  'El frejol le devuelve fuerza a tu tierra y el maíz aguanta mejor el '
          'clima que el arroz.':
      'Beans give strength back to your soil and maize handles the weather '
      'better than rice.',
  'Devuelve nitrógeno a la tierra, corta las plagas del arroz y usa la '
          'mitad de agua.':
      'It returns nitrogen to the soil, breaks the rice pest cycle and uses '
      'half the water.',
  'Siembra el maíz entre el 1 y el 20 de diciembre. Cosecha antes de las '
          'lluvias más fuertes de marzo.':
      'Plant the maize between December 1 and 20. Harvest before the '
      'heaviest rains in March.',
  'usa menos que el arroz': 'uses less than rice',
  'En años lluviosos aumentan las plagas del algodón: revisa con tu '
          'técnico cómo controlarlas.':
      'In rainy years cotton pests increase: check with your extension agent '
      'how to control them.',
  'Siembra el algodón en la primera quincena de diciembre.':
      'Plant the cotton in the first half of December.',
  'usa la menor cantidad': 'uses the least',
  'Son los cultivos que menos riego necesitan, y el frejol prepara la '
          'tierra para el maíz.':
      'These are the crops that need the least irrigation, and the beans '
      'prepare the soil for the maize.',
  'Frejol y maíz necesitan menos agua (evapotranspiración de ECOSTRESS y '
          'FAO-56). El agua subterránea del valle viene bajando (GRACE).':
      'Beans and maize need less water (evapotranspiration from ECOSTRESS '
      "and FAO-56). The valley's groundwater has been dropping (GRACE).",
  'Es la opción que menos agua usa y el frejol prepara la tierra para el '
          'maíz.':
      'It is the option that uses the least water, and the beans prepare '
      'the soil for the maize.',
  'Confirma tu turno de riego con la junta de usuarios antes de sembrar.':
      "Confirm your irrigation turn with the water users' board before "
      'planting.',
  'Siembra el frejol cuando confirmes tu turno de riego.':
      'Plant the beans once your irrigation turn is confirmed.',

  'Con El Niño es muy arriesgado: el arroz se inunda y podrías perder '
          'casi la mitad de tu cosecha.':
      'With El Niño it is very risky: rice floods and you could lose almost '
      'half of your harvest.',
  'Cosechas parecido, pero gastas mucha más agua y cansas tu tierra.':
      'You harvest about the same, but you use much more water and tire your '
      'soil.',
  'Sin agua suficiente podrías perder más de la mitad de la cosecha.':
      'Without enough water you could lose more than half of the harvest.',
  'Ya conoces bien el cultivo.': 'You already know the crop well.',
  'Con lluvias fuertes puede inundarse y perder gran parte de la cosecha. '
          'Tu tierra se sigue cansando.':
      'With heavy rains it can flood and you can lose much of the harvest. '
      'Your soil keeps getting tired.',
  'No tenemos un análisis de suelo de tu parcela. El pronóstico puede '
          'cambiar si El Niño se debilita.':
      "We don't have a soil test of your plot. The forecast may change if El "
      'Niño weakens.',
  'Confirma con tu técnico la variedad de maíz para tu zona.':
      'Check with your extension agent which maize variety suits your area.',
  'El algodón aguanta bien el calor y la menestra después cuida tu tierra.':
      'Cotton handles heat well, and the pulses afterwards look after your '
      'soil.',
  'Su raíz profunda mejora la estructura de la tierra y la menestra la '
          'abona.':
      'Its deep roots improve soil structure and the pulses fertilize it.',
  'En años muy lluviosos el algodón pierde calidad. Los datos de suelo son '
          'estimados (SoilGrids).':
      'In very rainy years cotton loses quality. The soil data are estimates '
      '(SoilGrids).',

  // Avisos.
  'Lluvia fuerte el miércoles': 'Heavy rain on Wednesday',
  'Se esperan 40 mm. No abones ni apliques productos ese día.':
      "40 mm expected. Don't fertilize or spray that day.",
  'Pronóstico del día': "Today's forecast",
  'Tu suelo está muy húmedo': 'Your soil is very wet',
  'No riegues esta semana. Espera hasta el jueves para sembrar.':
      "Don't irrigate this week. Wait until Thursday to plant.",
  // Datos de ejemplo de la integración con el backend (agua, riesgo,
  // rotación propia y textura de la tierra).
  'Con lluvias fuertes, ': 'With heavy rains, ',
  'Con lluvias fuertes el arroz puede inundarse y pierdes la campaña; además tu tierra se cansa más.':
      'With heavy rains the rice can flood and you lose the season; your soil also gets more tired.',
  'Gastas mucha más agua que con cualquier rotación y cansas tu tierra.':
      'You use much more water than with any rotation and you tire your soil.',
  'En un año seco puede faltarte agua para terminar la campaña.':
      'In a dry year you may run out of water to finish the season.',
  'Ya conoces el cultivo y tienes comprador.':
      'You already know the crop and have a buyer.',
  'Con lluvias fuertes puede inundarse y perder la campaña. Tu tierra se sigue cansando.':
      'With heavy rains it can flood and you can lose the season. Your soil keeps getting tired.',
  'No tenemos un análisis de suelo de tu parcela. El precio del maíz en la cosecha puede cambiar.':
      'We don\'t have a soil test of your plot. The price of maize at harvest can change.',
  'Confirma con tu técnico la variedad de maíz para tu zona y si hay comprador cerca.':
      'Check with your technician which maize variety suits your area and whether there is a buyer nearby.',
  'El algodón tolera bien el calor y la menestra después cuida tu tierra.':
      'Cotton handles heat well and the pulses afterwards take care of your soil.',
  'No sabemos si tienes comprador o desmotadora cerca. Los precios del algodón varían mucho.':
      'We don\'t know if you have a buyer or a cotton gin nearby. Cotton prices vary a lot.',
  'Es la secuencia que armaste tú.': 'It\'s the sequence you built.',
  'Puedes probar combinaciones y ver cómo cambian agua y tierra.':
      'You can try combinations and see how water and soil change.',
  'No sabemos si tienes comprador para todos estos cultivos ni si tu turno de riego alcanza.':
      'We don\'t know if you have buyers for all these crops or if your irrigation turn is enough.',
  'Conversa esta secuencia con tu técnico antes de sembrar.':
      'Talk this sequence over with your technician before planting.',
  'Siembra {crop} en la fecha que elegiste y sigue con los demás cultivos al cosechar.':
      'Plant {crop} on the date you chose and continue with the other crops after each harvest.',
  'Menos riesgo de clima': 'Lower weather risk',
  'tener menos riesgo de clima': 'have lower weather risk',
  'Arenosa': 'Sandy',
  'Se desarma en la mano y se siente como arena. El agua se va rápido.':
      'It falls apart in your hand and feels like sand. Water drains fast.',
  'Franca': 'Loamy',
  'Se hace bola húmeda pero se rompe sin esfuerzo. Guarda bien el agua.':
      'It forms a moist ball but breaks easily. It holds water well.',
  'Arcillosa': 'Clayey',
  'Se pega en la mano y se parte en terrones duros al secarse. Se encharca.':
      'It sticks to your hand and splits into hard clods when dry. It gets waterlogged.',
  '¿A cuál de estas se parece tu tierra?':
      'Which of these does your soil look like?',
  // Frases corregidas: sin mediciones de satélite que no existen.
  'Dato de ejemplo: con datos reales, aquí verás cuánta lluvia midió el satélite en tu chacra en los últimos 30 días.':
      'Sample data: with real data, here you\'ll see how much rain the satellite measured in your field over the last 30 days.',
  'Se calcula igual que las demás opciones, con el agua que pide cada cultivo.':
      'It\'s calculated like the other options, with the water each crop needs.',
  'Tu parcela lleva 3 campañas de arroz. Es el cultivo que más agua pide.':
      'Your plot has had 3 rice seasons in a row. It\'s the crop that needs the most water.',
  'El maíz aguanta mejor que el arroz los años muy lluviosos o muy secos, y el frejol le deja nitrógeno a la tierra.':
      'Maize handles very wet or very dry years better than rice, and beans leave nitrogen in the soil.',
  'El algodón tolera bien el calor y tiene historia en el valle. La menestra fija nitrógeno.':
      'Cotton tolerates heat well and has a history in the valley. Pulses fix nitrogen.',
  'Frejol y maíz necesitan menos riego que el arroz.':
      'Beans and maize need less irrigation than rice.',
  'Con lluvias muy fuertes el frejol rinde menos. Los datos de tu tierra son estimados.':
      'With very heavy rains beans yield less. The data about your soil are estimates.',
  'Aviso de ejemplo': 'Sample alert',
  // Aviso del ENFEN rotulado como ejemplo.
  'Ejemplo: cambió el pronóstico de El Niño':
      'Example: the El Niño forecast changed',
  'Así te avisaremos si cambia tu recomendación. Toca para escuchar.':
      'This is how we\'ll let you know if your recommendation changes. Tap to listen.',
  'AVISO DE EJEMPLO': 'SAMPLE ALERT',
  'Doña Rosa, este es un ejemplo de cómo te avisaremos cuando el ENFEN cambie su pronóstico de El Niño.':
      'Doña Rosa, this is an example of how we\'ll let you know when ENFEN changes its El Niño forecast.',
  'Si vienen **lluvias fuertes**, te mostraremos qué te conviene sembrar en ese caso.':
      'If **heavy rains** are coming, we\'ll show you what suits you best to plant in that case.',
  'Toca el botón para verlo ahora.': 'Tap the button to see it now.',
  '{first} y {second} son de la misma familia de plantas. Sembrarlas '
          'seguidas cansa la tierra y deja más plagas: prueba poner una '
          'menestra entre ellas.':
      '{first} and {second} belong to the same plant family. Planting them '
      'one after the other tires the soil and brings more pests: try putting '
      'a pulse crop between them.',
};

/// Quechua (borrador, pendiente de revisión): solo nombres de cultivos. El
/// resto de los datos de ejemplo se muestra en español.
const mockTextsQu = <String, String>{
  'Maíz': 'Sara',
  'Frejol': 'Purutu',
  'Algodón': 'Utku',
  'Otro': 'Huk',
};
