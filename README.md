# surfaceair


Uma aplicação desenvolvida com Flutter e Dart para aparelhos móveis (Android) com o objetivo de apresentar a solução do
desafio Surface to Air (Quality) da NASA, no Hackathon International Space Apps sediado
na cidade de Itajubá, MG - Brasil.

A solução proposta pela equipe foi criar um aplicativo que apresente ao cidadão (usuário) resultados
sobre a qualidade do ar em um determinado local, através de mapas para promover a interação e uma 
análise de dados de forma prática. Além disso, também foi criada uma API utilizando a tecnologia
GraphQL afim de solucionar problema quanto a inserção de dados gerados por cidadãos especializados
na área e que desejam compartilhar seus dados, na prática os sensores utilizados poderiam automatizar
o fluxo de dados através de uma requisição POST para a API criada. Essa funcionalidade é representada
através de um formulário no aplicativo, a construção da API foi baseada na API disponibilizada na página
do desafio, mantendo assim suas características prevendo uma maior facilidade para integrar os dados 
em trabalhos futuros.

Links: 
    - https://docs.openaq.org/#api-Latest-GetLatest (Utilizado como base para construção da API)
    - https://aqicn.org/faq/2015-07-28/air-quality-widget-new-improved-feed/ (Utilizado no Mapa do app)


Iniciando Projeto:

Pelo fato do projeto utilizar os serviços do Google para apresentação do mapa, então é necessário que
o projeto seja inicialmente configurado seguindo os passos:
    1 - Criar projeto no Firebase;
    2 - Seguir passo a passo de configuração do projeto no Firebase;
    3 - Acessar: https://console.cloud.google.com/home/;
    4 - Selecionar o projeto criado no Firebase;
    5 - Acessar a opção "Ir para a visão geral de APIs" apresentada na dashboard do projeto;
    6 - Clicar em "Ativar APIs e Serviços" localizado no meio da tela;
    7 - Ativar as seguintes APIs:
        - Maps SDK for Android;
        - Geocoding API;
        - Geolocation API;
        - Maps Embed API;
        - Maps JavaScript API;
        - Maps Static API; e
        - Places API.
    8 - Acessar alguma API e buscar em "Credenciais" por "Android Key" e copiá-la e alterar em
    <Project/android/app/src/main/AndroidManifest.xml>:
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="api_KEY"/>
