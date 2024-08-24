# Estructura

Rails trabaja bajo el modelo MVC y desde el momento que creamos el proyecto este ya cuenta con la estructura necesaria, nosotros solo agregaremos la logica de negocio y tal vez algunos directorios extras para plugins o funciones especiales.

Para inicializar un proyecto se utiliza el comando `rails new api_name --api`, para designar que base de datos usaremos desde el comienzo de usa el parametro `-d` aunque se puede hacer el cambio en cualquier momento desde en [configuracion bd](config/database.yml).

## [Rutas](config/routes.rb)

Como lo dice su nombre define el ruteo para los diferentes endpoints, esta fuertemente ligado con la estructura de carpetas al momento definir los controladores.
Cuenta con diferentes funciones para declarar las rutas de manera avanzada, sin embargo, las mas comunes son

1. resources: Representan un conjunto de acciones dentro de un controlador, el nombre del recurso sera el nombre del controlador, por defecto, al declarar un recurso este podra ejecutar las acciones GET, POST, PUT, DELETE, (**INDEX, CREATE, UPDATE, DELETE**) respectivamente en el controlador, sin embargo, se puede limitar el uso de estos con la palabra reservada `only`, si se desea agregar mas funciones se haran dentro de un bloque `do end` desde el propio recurso, pueden ser acciones simples (se indicara el tipo de peticion, y su nombre sera la funcion en el controlador), u otros recursos (esto es un poco mas complejo y se suele utilzar *aunque no es obligatorio y se puede hacer de manera convecional* cuando hay relacion entre modelos, por ejemplo, una seccion de comentarios dentro un post).

![resource](https://1drv.ms/i/c/7460f33893855caf/IQMD96CYgI4LSo67CcQFMRB6Aad1iDf-92sTVt6GH4vyrQs?width=410&height=408)

2. namespace: Sirve para agrupar rutas sin generar recursos, representarian una carpeta identada dentro de la carpeta controladores

![namespace](https://1drv.ms/i/c/7460f33893855caf/IQNqOen5A8JdRq529iYee6n6AaG7Rlzi87KHqJdBor1gG8I?width=1042&height=231)

Si no se utiliza ninguna de las features que provee rails se pueden declarar las rutas una a una, pero es mas laborioso y desorganizado para rutas que pueden ser encapsuladas

## [Controladores](app/controllers/)


