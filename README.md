# Movies Test

[Demo](https://www.youtube.com/watch?v=ZIXGpXk6Mpk)

## Decisiones de arquitectura

La arquitectura de **Movies Test** está basada en el patrón MVVM (Model-View-ViewModel), con los siguientes objetivos:

- La Vista (y el ViewController) no conoce la capa de negocio (Modelo).
- El ViewModel almacena un estado, y acondiciona el Modelo para el consumo de la Vista. 
- El estado almacenado dentro del ViewModel es observable. Para este motivo se ha utilizado RxSwift/RxCocoa y Driver y BehaviorRelay como las Units observables.
- El ViewModel puede variar independientemente de la vista, porque no la conoce.
- En ViewModel se inyecta dentro del ViewController. La inyección de dependencias en este caso puede ser muy provechosa, porque permite que ambos componentes varíen en forma independiente, y además facilita el testing del ViewController.
- Las clases necesarias para la representación de una determinada pantalla (o un fragmento de una pantalla), se empaquetan en **Módulos**. Un Módulo en la arquitectura de MoviesTest es una carpeta con todos los archivos necesarios dentro de ella para el funcionamiento de una pantalla.
- La forma de acceder a un módulo desde el exterior del mismo es a través de la instanciación de un objeto **Builder**, que contiene un método **build()** que devuelve un UIViewController, que puede ser utilizado para navegar hacia el mismo, o para embeberlo en otro ViewController.
- Un Builder recibe en su constructor, los datos necesarios para la instanciación de la pantalla. Al llamarse al método **build()**, primero se construye el ViewModel, y luego se construye el ViewController, al que se le inyecta el ViewModel.
- Para mantener consistencia en el estado de la aplicación, un Builder puede recibir un Observable o similar en el constructor, para crear dependencias entre los streams, y centralizar el control del estado lo más arriba posible en el árbol de módulos.
- Un módulo podría ser empaquetado en un Framework dinámico. Por motivos de sencillez dentro del contexto de la prueba, decidí no hacerlo.
- La navegación entre módulos también podría ser orquestada por objetos llamados **Coordinators**. Al igual que el punto anterior, preferí exponer un código conciso a uno que padece sobreingeniería.
- Para las entidades de la capa de modelo se utilizó Codable de Swift 4+.
- Para networking se utilizó una capa custom desarrollada sobre URLSession, llamada **Conn** (más información sobre Conn [aquí](https://medium.com/@ortizfernandomartin))
- Para la base de datos se utilizó CoreData. Las entidades de CoreData se desarrollaron como clases separadas de las principales del modelo (las que implementan Codable), para que la base de datos pudiera variar independientemente del backend.
- Las fuentes de datos (CoreData, Networking, etc.) implementan el protocolo MoviesSource, que contiene funciones necesarias para obtener películas, realizar búsquedas por texto, etc.
- Existe una tercera fuente de datos, fuera de CoreData y la de Networking, que llamé **CacheableMoviesSource**, que realiza las búsquedas de películas, la obtención de películas por texto, etc. combinando las otras dos fuentes, y evaluando la conexión a internet para optar entre una y la otra.
- **No se utilizó Storyboards**. Con el propósito de poder instanciar los ViewControllers con ViewModels, entre otros, se optó por la utilización de Xibs en algunos casos, y código Swift en otros.

## Módulos de MoviesTest

Los módulos presentes en MoviesTest son los siguientes:

- **Home**: El módulo de Home es el módulo principal de la pantalla inicial, en la que se cuenta con selectores para las tres categorías (Popular, Top Rated y Upcoming) y una barra de búsqueda.
- **Movies List**: El módulo de lista de películas es un módulo hijo del módulo Home. Su función es mostrar una lista/grilla de películas. Se comunica con el módulo de Home a través de la observación de Driver<Array<Movie>>, que el módulo de Home se encarga de mantener actualizado. Asimismo, avisa sobre el evento de "fin de lista alcanzado" por medio de la exposición de un PublishSubject<Void>. El módulo de Home tiene un módulo de lista de películas por cada categoría (es decir, tres).
- **Search List**: El módulo de lista de búsqueda contiene una lista con películas que son el resultado de búsquedas en el módulo de Home. Al igual que el módulo de lista de películas, el módulo de lista de búsqueda  observa un Driver<Array<Movie>>, que el módulo de Home se encarga de mantener actualizado. Asimismo, expone un PublishSubject<SearchCriteriaItem> para avisar sobre un cambio en el criterio de búsqueda seleccionado y un PublishSubject<SearchMovieEntity> para avisar sobre la selección de una película.
- **Movie Detail**: El módulo de detalle de película no depende de Home (no es hijo de este módulo), sino que es un módulo independiente, que muestra información sobre una película, videos, etc.

Cada módulo cuenta con un view controller, un view model opcional (casi siempre se utiliza), un builder, y opcionalmente, una cantidad de structs que definen el modelo de datos que va a ser utilizado en alguna parte de la vista del módulo, llamadas **Entities**.

## Observables

La arquitectura de MoviesTest se basa en gran medida en el uso de Observable y los distintos Traits de RxCocoa, como ser BehaviorSubject, PublishSubject y Driver. El objetivo que se busca mediante la utilización de estas estructuras es lograr que la vista sea en la mayor medida de lo posible, una función pura del estado. Este estado se encapsula a su vez en un objeto llamado ViewModel, que expone un acceso controlado a su modificación.

## Soporte offline

El soporte offline dentro de MoviesTest se realiza por medio de CoreData. Se utiliza una clase llamada LocalMovie, en lugar de usar la clase del modelo llamada Movie, principalmente para dejar que ambas varíen en forma independiente.

Para poder realizar en modo transparente a los módulos las consultas a las fuentes de datos (ya sea CoreData o la API), se creó un protocolo llamado **MoviesSource** con los métodos relacionados con la búsqueda y obtención de películas y videos.

Luego, se crearon tres objetos que implementan **MoviesSource**:

1. **LocalMoviesSource**: Realiza la búsqueda de películas a partir de la base de datos.
2. **RemoteMoviesSource**: Realiza la búsqueda de películas a partir de llamadas HTTP a la API.
3. **CacheableMoviesSource**: (podría haber encontrado un mejor nombre...), realiza llamadas a LocalMoviesSource y RemoteMoviesSource según el estado de conexión.

## Preguntas y respuestas

> ¿En qué consiste el principio de responsabilidad única? ¿Cuál es su propósito?

El principio de responsabilidad única consiste en que cada construcción dentro del código debe perseguir un único objetivo. Con construcción me refiero a clases, estructuras, funciones, etc. 

El propósito del principio de responsabilidad única es obtener un código limpio, con alta cohesión y bajo acoplamiento, que sea mantenible.

Alta cohesión significa que dentro de la construcción se tiene todo lo necesario para la concreción del objetivo.
Bajo acoplamiento significa que cada construcción es lo suficientemente independiente de las demás como para permitir que éstas varíen sin afectar a las otras.

La otra gran ventaja del principio de responsabilidad única es que el desarrollo de pruebas unitarias se torna mucho más sencillo.

> ¿Qué características tiene, en su opinión, un "buen" código, o código limpio?

Para responder esta pregunta debemos partir de que el código es una herramienta de comunicación, no solo de persona a máquina (para la ejecución del mismo), sino también,
y más importante aún, es una construcción que permite el entendimiento entre personas sobre el razonamiento de un problema que intenta ser resuelto.

Como tal, el buen código debe ser una gran herramienta de comunicación, y por lo tanto:

- Debe ser conciso.
- Debe ser sencillo.
- Debe tener el grado justo de abstracción. No debe pecar de extrema sencillez, ni de sobreingeniería.
- No necesita comentarios, o casi no los necesita, porque su poder de expresión es tal que se explica a sí mismo.

El código limpio es claro, y autodocumentado, es mantenible y no sorprende al realizar modificaciones en el mismo.

La arquitectura que rige al código limpio, también debe estar concebida bajo las mismas bases. Debe tener en cuenta a la gente y debe ser clara y promover la comunicación eficaz entre los participantes.

Algunas consideraciones algo más prácticas sobre el código limpio en mi opinión:

- El largo de las funciones en ningún caso debe exceder el tamaño de la pantalla.
- Cualquier comportamiento en un objeto que varíe según el contexto de utilización, debe recibir por inyección (preferentemente en el constructor), las dependencias que definen el contexto.
- Todo el código debe verse como si hubiese sido desarrollado por una sola persona, independientemente de la cantidad de desarrolladores que intervinieron en su construcción. Esto lleva a que las reglas de estilo definidas por el equipo deben ser respetadas.
- Debe preferirse la composición a la herencia.
- Debe haber preferencia por la inmutabilidad, las funciones puras y los cambios de estado predecibles.

