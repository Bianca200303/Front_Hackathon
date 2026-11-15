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
  'El verdor de tus cultivos bajó en los últimos 5 años (satélite NASA).':
      'The greenness of your crops has dropped over the last 5 years '
      '(NASA satellite).',
  'Tiene poca materia orgánica.': 'It has little organic matter.',
  'Es lo que siembras hoy. Lo comparamos para que veas la diferencia.':
      "It's what you plant today. We compare it so you can see the "
      'difference.',
  'Tu parcela lleva 3 campañas de arroz y su verdor bajó en 5 años '
          '(Landsat). Es el cultivo que más agua consume (ECOSTRESS y '
          'FAO-56).':
      'Your plot has had 3 seasons of rice and its greenness dropped over 5 '
      'years (Landsat). It is the crop that uses the most water (ECOSTRESS '
      'and FAO-56).',
  'Depende de cuánta agua tenga Poechos este año.':
      'It depends on how much water Poechos has this year.',
  'usa la mitad que el arroz': 'uses half as much as rice',
  'El frejol le devuelve fuerza a tu tierra y el maíz aguanta mejor el '
          'clima que el arroz.':
      'Beans give strength back to your soil and maize handles the weather '
      'better than rice.',
  'En los años con El Niño (1998, 2017 y 2023) el maíz del valle perdió '
          'menos verdor que el arroz (lluvia GPM y verdor MODIS). El frejol '
          'fija nitrógeno en la tierra (FAO).':
      'In El Niño years (1998, 2017 and 2023) maize in the valley lost less '
      'greenness than rice (GPM rainfall and MODIS greenness). Beans fix '
      'nitrogen in the soil (FAO).',
  'Devuelve nitrógeno a la tierra, corta las plagas del arroz y usa la '
          'mitad de agua.':
      'It returns nitrogen to the soil, breaks the rice pest cycle and uses '
      'half the water.',
  'Siembra el maíz entre el 1 y el 20 de diciembre. Cosecha antes de las '
          'lluvias más fuertes de marzo.':
      'Plant the maize between December 1 and 20. Harvest before the '
      'heaviest rains in March.',
  'usa menos que el arroz': 'uses less than rice',
  'El algodón tolera bien el calor (FAO ECOCROP) y tiene historia en el '
          'valle. La menestra fija nitrógeno.':
      'Cotton tolerates heat well (FAO ECOCROP) and has a history in the '
      'valley. Pulses fix nitrogen.',
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
  'Con lluvias muy fuertes el frejol rinde menos. Los datos de suelo son '
          'estimados (SoilGrids).':
      'With very heavy rains beans yield less. The soil data are estimates '
      '(SoilGrids).',
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
  'Satélite NASA (humedad del suelo)': 'NASA satellite (soil moisture)',
  'Cambió el pronóstico de El Niño': 'The El Niño forecast changed',
  'Tu recomendación cambió de arroz a maíz. Toca para escuchar.':
      'Your recommendation changed from rice to maize. Tap to listen.',
  'Comunicado ENFEN': 'ENFEN bulletin',
  'CAMBIÓ EL PRONÓSTICO': 'THE FORECAST CHANGED',
  'Doña Rosa, el ENFEN anunció que El Niño vendría más fuerte.':
      'Doña Rosa, ENFEN announced that El Niño would come stronger.',
  'Para su parcela ya no le recomendamos **arroz**. Ahora le conviene '
          '**maíz y después frejol**.':
      'For your plot we no longer recommend **rice**. Now your best option '
      'is **maize, then beans**.',
  'Tiene hasta el **15 de diciembre** para decidir.':
      'You have until **December 15** to decide.',
};

/// Quechua (borrador, pendiente de revisión): solo nombres de cultivos. El
/// resto de los datos de ejemplo se muestra en español.
const mockTextsQu = <String, String>{
  'Maíz': 'Sara',
  'Frejol': 'Purutu',
  'Algodón': 'Utku',
  'Otro': 'Huk',
};
