# Movies Test

![SampleGif](http://freegifmaker.me/images/2e4Wm/)

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

## Preguntas y respuestas

> ¿En qué consiste el principio de responsabilidad única? ¿Cuál es su propósito?

El principio de responsabilidad única consiste en que cada construcción dentro del código debe perseguir un único objetivo. Con construcción me refiero a clases, estructuras, funciones, etc. 

El propósito del principio de responsabilidad única es obtener un código limpio, con alta cohesión y bajo acoplamiento, que sea mantenible.

Alta cohesión significa que dentro de la construcción se tiene todo lo necesario para la concreción del objetivo.
Bajo acoplamiento significa que cada construcción es lo suficientemente independiente de las demás como para permitir que éstas varíen sin afectar a las otras.

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

