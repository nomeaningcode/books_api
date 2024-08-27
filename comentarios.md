# Estructura

Rails trabaja bajo el modelo MVC y desde el momento que creamos el proyecto este ya cuenta con la estructura necesaria, nosotros solo agregaremos la logica de negocio, tal vez algunos directorios extras para plugins o funciones especiales.

Para inicializar un proyecto se utiliza el comando `rails new api_name --api`, para designar que base de datos usaremos desde el comienzo se usa el parametro `-d` aunque se puede hacer el cambio en cualquier momento desde en [configuracion bd](config/database.yml).

## [Rutas](config/routes.rb)

Como lo dice su nombre define el ruteo para los diferentes endpoints, esta fuertemente ligado con la estructura de carpetas al momento definir los controladores.
Cuenta con diferentes funciones para declarar las rutas de manera avanzada, sin embargo, las mas comunes son

1. resources: Representan un controlador y su conjunto de acciones, el nombre del recurso sera el nombre del controlador, por defecto, al declarar un recurso este podra ejecutar las acciones GET, POST, PUT, DELETE, (**INDEX, CREATE, UPDATE, DESTROY** respectivamente en el controlador), sin embargo, se puede limitar el uso de estos con la palabra reservada `only`, si se desea agregar mas funciones se haran dentro de un bloque `do end` desde el propio recurso, pueden ser acciones simples (se indicara el tipo de peticion, y su nombre sera la funcion en el controlador), u otros recursos (esto es un poco mas complejo y se suele utilzar *aunque no es obligatorio y se puede hacer de manera convecional* cuando hay relacion entre modelos, por ejemplo, una seccion de comentarios dentro un post).

[img resources](https://1drv.ms/i/c/7460f33893855caf/EQP3oJiAjgtKjrsJxAUxEHoBX6GMbvlvYXVmhQ0V9Lz_vQ?e=hdmJ9b)

2. namespace: Sirve para agrupar rutas sin generar recursos, representarian una carpeta identada dentro de la carpeta controladores

[img namespace](https://1drv.ms/i/c/7460f33893855caf/EWo56fkDwl1Grnb2Jh57qfoBcnfIIcJ_jwOPn2XCxAMRvQ?e=MokNU7)

*Si no se utiliza ninguna de las features que provee rails se pueden declarar las rutas una a una, pero es mas laborioso y desorganizado para rutas que pueden ser encapsuladas*

## [Controladores](app/controllers/)

Es una clase que hereda de AplicationController por ende cualquier funcion que haya sido declarada en esta puede ser llamada desde cualquier otro controlador.
El nombre del archivo debe de ser el mismo que el nombre del controlador `example_controller.rb` -> `ExampleController`
Como ya se menciono cada recurso representa un controlador y cada accion una funcion, las acciones basicas que no necesitan ser declaradas dentro del recurso si deben de ser definidas dentro del controlador, de lo contrario retornara error al querer llamarlas

```rb
# app/controllers/example_controller.rb
class ExampleController < ApplicationController
  def index
    # GET
  end
  def show
    # GET AN ELEMENT BY ID
  end
  def create
    # POST
  end
  def update
    # POST
  end
  def destroy
    # DELETE
  end
end
```

Si la ruta se encuentra identada en namespace's hay 2 maneras de declarar el controlador

```rb
module Api
  module V1
    class ExampleClass < ApplicationController
    end
  end
end

# scope resolution operator ::
# Es similar al primer caso, sin embargo, puede cambiar el comportamiento de algunas acciones avanzadas, como controladores para mostrar datos en la vistas o apis no he presentado problemas
class Api::V1::ExampleClass < ApplicationController
end
```

Generar un cotrolador se puede hace con el comando (scaffold) 

```sh
# g -> generate, se puede usar ambos formatos
rails g controller controller_name funcion_uno funcion_dos etc

# para rutas identadas
rails g controller api/v1/controller_name funcion_uno funcion_dos etc
```
la ventaja de usar este comando es que crea las carpetas y archivos para otras areas como testing, configuracion, etc. De igual manera se pueden crear manualmente pero en caso de necesitar las otras carpetas se haran una a una.
Una 'desventaja' de este comando es que crea las rutas en formato individual incluso si ya se han declarado, basta con borrarlas para evitar que esten duplicadas.

### Funciones

La ultima linea dentro de una funcion es lo que retornara esta, no es necesario usar la palabra reservada `return`, aunque igual se puede utilizar sin ningun problema, en el caso de la api usamos la propidad `render json: ` seguido del(los) dato(s) a retornar (esto si es obligatorio), de igual manera se le puede acompañar de manera opcional el codigo http de status ya sea como numero o con [palabra clave](http://www.railsstatuscodes.com/), es opcional pero de no ponerle uno siempre regresa 200 (excepto en errores criticos 400,500)

```rb
def create
  book = Book.new(book_params)

  if book.save
    render json: {value_a: '1', value_b: '2'}, status: :created
  else
    render json: book.errors, status: :unprocessable_entity
  end
end
```

#### Protected y Private

Por default todas la funciones dentro de un controlador son publicas, para evitar esto se usan las palabras reservadas `protected` y `private`, basta con escribirla y todo el codigo que este debajo de estas adquiriran la propiedad, no es necesario identar o encapsular en algun bloque, las funciones `protected` solo son accesibles por el propio controlador y aquellos que hereden de este, las funciones `private` unicamente son visible al propio controlador

## [Modelo](app/models/)

Previo a comenzar a trabaja con el modelo se debe de crear la base datos, de hecho, al crear la app este sera uno de los primeros pasos, `rails db:create`

Para generar un modelo primero se usa el comando `rails g model_name` (**el nombre del modelo debe de estar en singular**) seguido de los atributos que este tendra y que tipo de dato es, cada atributo debera de ser separado con un ' ', las foreign key llevan el nombre de la tabla en singular a la que hara referencia con la palabra clave `references`

```sh
# el nombre del modelo debe ser singular y empezar con mayuscula
rails g model Author name:string age:int otro:float

# aqui hacemos referecia al modelo creado previamente
rails g model Book title:string author:references
```

**como tal este comando no crea el modelo, sino, mas bien, una migración que indicara como sera el modelo**, una vez que se ejecuten esos comandos se creara un archivo como [este](db/migrate/20240717213113_create_books.rb), esta es una migracion que indicara como sera el modelo, en este punto aun puedes modificar el archivo para modificar los nombres de columnas, agregar nuevas, o modificar el tipo de datos.
Para consolidar la creación del modelo se usara el comando `rails db:migrate`, ahora dentro del [esquema](db/schema.rb) se actualizara el diseño de nuestra base y en la carpeta [modelos](app/models/) estara disponible la clase del modelo para agregar logica en esta, por default a diferencia de otras tecnologias no vinen los atributos del modelo ni es necesario agregarlos manualmente a menos que se quieran agregar validaciones, por ejemplo [books](app/models/book.rb).

### Modificar modelos
En caso de querer agregar, modificar, eliminar algunna columna se debe de crear una migración `rails g migration NombreMigracion`, se recomienda ser explicito en el nombre de la migración (ex: `rails g migration AddColumnPagesToBooks`) de esta manera es mas facil identificarla y en migraciones sencillas rails es capaz de entender el cambio y proveer un `esqueleto` para la migración, en caso de crear un archivo vacio la estructura de la migracion es algo asi

```rb
class NombreMigracion < ActiveRecord::Migration[7.0]
  def change
    accion_para_hacer :nombre_tabla_plural, :nombre_atributo, :tipo_atributo
  end
end
```

### Rollback
En caso de que exista algun problema con las ultimas migraciones hechas se puede ejecutar un rollback, sin embargo, esto solo eliminara la ultima migracion puntual, para eliminar varios cambios se usa el parametro `STEP=n`, cada migracion representa un STEP por lo que si se realizaron 2,3,4 migraciones este seria `n`

```sh
rails db:rollback

rails db:rollback STEP=2
```

[mas sobre migraciones](https://railsguides.es/active_record_migrations.html#generaci%C3%B3n-de-archivos-de-migraci%C3%B3n)

## Librerias

Las librerias o plugins aqui son llamados gemas y existe un [archivo](Gemfile) para declarar todas aquellas que se vayan a utilizar, para agregar alguna solo se debe de usar la palabra clave `gem` seguido por el nombre de esta en formato string `"nombre"`, igualmente si se desea se puede especificar la version a usar con `, "~> version"`, de no hacerlo usa por default la ultima, en el archivo hay 2 bloques, `development` y `development` test como su nombre lo indica aquellas gemas que se declaren dentro de estos se usaran unicamente en dichos escenarios, aquellas que no esten en ninguno se usaran siempre

```rb
gem 'nombre'
gem 'otra_gema', '~> 1.2.3'
```

Cuando se crea/clona el proyecto por primera vez y cada que se agrega/elimina una gema del `Gemfile` se debe de ejecutar el comando `bundle install`