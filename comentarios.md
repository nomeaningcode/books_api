# Estructura

Rails trabaja bajo el modelo MVC y desde el momento que creamos el proyecto este ya cuenta con la estructura necesaria, nosotros solo agregaremos la logica de negocio y tal vez algunos directorios extras para plugins o funciones especiales.

Para inicializar un proyecto se utiliza el comando `rails new api_name --api`, para designar que base de datos usaremos desde el comienzo de usa el parametro `-d` aunque se puede hacer el cambio en cualquier momento desde en [configuracion bd](config/database.yml).

## [Rutas](config/routes.rb)

Como lo dice su nombre define el ruteo para los diferentes endpoints, esta fuertemente ligado con la estructura de carpetas al momento definir los controladores.
Cuenta con diferentes funciones para declarar las rutas de manera avanzada, sin embargo, las mas comunes son

1. resources: Representan un conjunto de acciones dentro de un controlador, el nombre del recurso sera el nombre del controlador, por defecto, al declarar un recurso este podra ejecutar las acciones GET, POST, PUT, DELETE, (**INDEX, CREATE, UPDATE, DESTROY**) respectivamente en el controlador, sin embargo, se puede limitar el uso de estos con la palabra reservada `only`, si se desea agregar mas funciones se haran dentro de un bloque `do end` desde el propio recurso, pueden ser acciones simples (se indicara el tipo de peticion, y su nombre sera la funcion en el controlador), u otros recursos (esto es un poco mas complejo y se suele utilzar *aunque no es obligatorio y se puede hacer de manera convecional* cuando hay relacion entre modelos, por ejemplo, una seccion de comentarios dentro un post).

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
### Funciones

La ultima linea dentro de una funcion es lo que retornara esta, no es necesario usar la palabra reservara `return`, aunque igual se puede utilizar sin ningun problema, en el caso de la api usamos la propidad `render json: ` seguido del(los) dato(s) a retornar (esto si es obligatorio), de igual manera se le puede acompañar de manera opcional el codigo http de status ya sea como numero o con [palabra clave](http://www.railsstatuscodes.com/), es opcional pero de no ponerle uno siempre regresa 200 (excepto en errores criticos 400,500)

```rb
def create
  book = Book.new(book_params)
  UpdateSkuJob.perform_later(book_params[:title])

  if book.save
    render json: BookRepresenter.new(book).as_json, status: :created
  else
    render json: book.errors, status: :unprocessable_entity
  end
end
```

#### Protected y Private

Por default todas la funciones dentro de un controlador son publicas, para evitar esto se usan las palabras reservadas `protected` y `private`, basta con escribirla y todo el codigo que este debajo de estas adquiriran la propiedad, no es necesario identar o encapsular en algun bloque, las funciones `protected` solo son accesibles por el propio controlador y aquellos que hereden de este, las funciones `private` unicamente son visible al propio controlador