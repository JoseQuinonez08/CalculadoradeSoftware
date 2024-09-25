class ProyectoSoftware
  def initialize
    @costo_personal_horas = 0
    @horas_trabajadas = 0
    @viaticos = 0
    @infraestructura = 0
    @gastos = 0
    @riesgo_porcentaje = 0
    @ganancia_porcentaje = 0
    @personas = []  # Lista para almacenar información de personas
  end

  def agregar_persona(costo_hora, horas_trabajadas)
    @personas << { costo_hora: costo_hora, horas_trabajadas: horas_trabajadas }
    @horas_trabajadas += horas_trabajadas
  end

  def calcular_costo
    costo_personal = @personas.sum { |p| p[:costo_hora] * p[:horas_trabajadas] } # |p| es un parámetro de bloque que representa cada elemento del array @personasa medida que se itera.
    costo_total = costo_personal + @viaticos + @infraestructura
    costo_total
  end

  def calcular_riesgo
    costo_total = calcular_costo #Invoca el metodo calcular costo.
    riesgo = costo_total * (@riesgo_porcentaje / 100.0)
    riesgo
  end

  def calcular_ganancia
    costo_total = calcular_costo #Invoca el metodo calcular costo.
    ganancia = costo_total * (@ganancia_porcentaje / 100.0)
    ganancia
  end

  def calcular_impuestos
    costo_total = calcular_costo
    riesgo = calcular_riesgo
    ganancia = calcular_ganancia
    retencion_fuente = (costo_total + @gastos + ganancia + riesgo) * 0.11
    reteica = retencion_fuente * 0.01
    iva = (costo_total + @gastos + riesgo + retencion_fuente) * 0.19
    [retencion_fuente, reteica, iva]
  end

  def solicitar_datos
    @viaticos = nil
    loop do
      print "Introduce el valor de los viáticos (debe ser un número positivo): "
      @viaticos = gets.chomp
      if valido_numero_positivo?(@viaticos)
        @viaticos = @viaticos.to_f
        break
      else
        puts "Entrada inválida. Por favor, ingrese un número positivo."
      end
    end
  
    @infraestructura = nil
    loop do
      print "Introduce el valor de la infraestructura (debe ser un número positivo): "
      @infraestructura = gets.chomp
      if valido_numero_positivo?(@infraestructura)
        @infraestructura = @infraestructura.to_f
        break      
      else
        puts "Entrada inválida. Por favor, ingrese un número positivo."
      end
    end
  
    @riesgo_porcentaje = nil
    loop do
      print "Introduce el porcentaje de riesgo (números entre 0 y 50): "
      @riesgo_porcentaje = gets.chomp
      if valido_porcentaje?(@riesgo_porcentaje, 0, 50)
        @riesgo_porcentaje = @riesgo_porcentaje.to_f
        break
      else
        puts "Entrada inválida. Por favor, ingrese un porcentaje entre 0 y 50."
      end
    end
  
    @ganancia_porcentaje = nil
    loop do
      print "Ingrese el porcentaje de ganancias (números del 0 al 60): "
      @ganancia_porcentaje = gets.chomp
      if valido_porcentaje?(@ganancia_porcentaje, 0, 60)
        @ganancia_porcentaje = @ganancia_porcentaje.to_f
        break
      else
        puts "Entrada inválida. Por favor, ingrese un porcentaje entre 0 y 60."
      end
    end
  end

  def agregar_gasto(nombre_gasto, cantidad)
    @gastos += cantidad  # Sumar la cantidad al total de gastos
    puts "Gasto '#{nombre_gasto}' agregado: #{cantidad}."
  end

  def inspeccionar_clase                                # Paradigma reflexivo, permite que el objeto conozca su propia clase y los métodos que posee.
    puts "Atributos del proyecto:"
    instance_variables.each do |var|                    # El método instance_variable_get(var) deja acceder al valor de una variable de instancia utilizando su nombre.
      puts "#{var}: #{instance_variable_get(var)}"      # Osea puedo acceder/ver los datos del programa en tiempo de ejecución.
    end

    puts "\nMétodos de instancia disponibles:"
    self.class.instance_methods(false).each do |method| # Lista de métodos de instancia disponibles en la clase
      puts method
    end
  end

  def cambiar_atributo(atributo, nuevo_valor) # Paradigma Reflexivo.
    if instance_variables.include?("@#{atributo}".to_sym) #To_sym convierte un string a un simbolo. 
      instance_variable_set("@#{atributo}".to_sym, nuevo_valor)
      puts "Atributo #{atributo} cambiado a #{nuevo_valor}."
    else
      puts "El atributo #{atributo} no existe."
    end
  end

  def agregar_metodo(nombre_metodo, &codigo_metodo)  # Paradigma Reflexivo. & operador que permite resivir un bloque de codigo como parametro.
    self.class.send(:define_method, nombre_metodo, &codigo_metodo)
    puts "Método #{nombre_metodo} agregado exitosamente."
  end

  def ejecutar_metodo(nombre_metodo, *args) # * Cantidad varible de argumentos
    if respond_to?(nombre_metodo)
      metodo = method(nombre_metodo)
      parametros_requeridos = metodo.parameters.size

      if args.size < parametros_requeridos
        puts "Se requieren #{parametros_requeridos} parámetros, pero se proporcionaron #{args.size}."
      else
        resultado = metodo.call(*args)
        puts "Resultado de #{nombre_metodo}: #{resultado}"
      end
    else
      puts "El método #{nombre_metodo} no existe o no es válido."
    end
  end
end

def ingresar_codigo_metodo
  puts "Introduce el código del método (no incluyas def ni end, solo el cuerpo)."
  lines = []

  while true
    line = gets.chomp
    break if line.empty?  # Salir si se ingresa una línea vacía
    lines << line
  end

  lines.join("\n")  # Retornar el cuerpo del método como una cadena
end

def solicitar_parametros(metodo)
  parametros = metodo.parameters
  num_parametros = parametros.size

  if num_parametros > 0
    puts "Este método requiere #{num_parametros} parámetros."
    params = []
    parametros.each do |param|
      print "Introduce el valor para #{param[1]}: "
      valor = gets.chomp
      params << valor.to_f  # Convertir a float para cálculos
    end
    params
  else
    []
  end
end
#Funciones para validación de datos
def valido_numero?(entrada)
  Float(entrada) rescue false
end

def valido_numero_positivo?(entrada)
  valido_numero?(entrada) && entrada.to_f > 0
end
def valido_porcentaje?(entrada, min, max)
  valido_numero?(entrada) && entrada.to_f.between?(min, max)
end
def main
  puts "Inicializando el proyecto..."
  proyecto = ProyectoSoftware.new

  proyecto.solicitar_datos

  loop do
    puts "\n¿Qué te gustaría hacer?"
    puts "1. Agregar persona"
    puts "2. Agregar gasto"
    puts "3. Calcular costo"
    puts "4. Calcular riesgo"
    puts "5. Calcular impuestos"
    puts "6. Inspeccionar clase"
    puts "7. Cambiar atributo"
    puts "8. Agregar nuevo método"
    puts "9. Ejecutar un método existente"
    puts "10. Salir"

    eleccion = gets.chomp

    case eleccion
    when "1"
      costo_hora = nil
      loop do
        print "Ingrese el costo por hora de la persona (debe ser un número positivo): "
        costo_hora = gets.chomp
        if valido_numero_positivo?(costo_hora)
          costo_hora = costo_hora.to_f
          break
        else
          puts "Entrada inválida. Por favor, ingrese un número positivo."
        end
      end

      horas_trabajadas = nil
      loop do
        print "Ingrese las horas trabajadas (debe ser un número positivo): "
        horas_trabajadas = gets.chomp
        if valido_numero_positivo?(horas_trabajadas)
          horas_trabajadas = horas_trabajadas.to_f
          break
        else
          puts "Entrada inválida. Por favor, ingrese un número positivo."
        end
      end

      proyecto.agregar_persona(costo_hora, horas_trabajadas)

    when "2"
      nombre_gasto = nil
      loop do
        print "Ingrese el nombre del gasto: "
        nombre_gasto = gets.chomp
        if nombre_gasto.strip.empty?
          puts "El nombre del gasto no puede estar vacío."
        else
          break
        end
      end

      cantidad = nil
      loop do
        print "Ingrese la cantidad del gasto (debe ser un número positivo): "
        cantidad = gets.chomp
        if valido_numero_positivo?(cantidad)
          cantidad = cantidad.to_f
          break
        else
          puts "Entrada inválida. Por favor, ingrese un número positivo."
        end
      end

      proyecto.agregar_gasto(nombre_gasto, cantidad)

    when "3"
      puts "El costo total es: #{proyecto.calcular_costo}"

    when "4"
      puts "El riesgo total es: #{proyecto.calcular_riesgo}"

    when "5"
      retencion_fuente, reteica, iva = proyecto.calcular_impuestos
      puts "Los impuestos son: Retención en la fuente: #{retencion_fuente}, Reteica: #{reteica}, IVA: #{iva}"

    when "6"
      proyecto.inspeccionar_clase

    when "7"
      print "¿Qué atributo quieres cambiar? "
      atributo = gets.chomp
      nuevo_valor = nil
      loop do
        print "Nuevo valor para #{atributo} (debe ser un número): "
        nuevo_valor = gets.chomp
        if valido_numero?(nuevo_valor)
          nuevo_valor = nuevo_valor.to_f
          break
        else
          puts "Entrada inválida. Por favor, ingrese un número válido."
        end
      end

      proyecto.cambiar_atributo(atributo, nuevo_valor)

    when "8"
      print "Nombre del nuevo método: "
      nombre_metodo = gets.chomp
      codigo_metodo = ingresar_codigo_metodo
      proyecto.agregar_metodo(nombre_metodo.to_sym) { eval(codigo_metodo) }

    when "9"
      print "Nombre del método que deseas ejecutar: "
      nombre_metodo = gets.chomp
      metodo = proyecto.method(nombre_metodo) rescue nil
      if metodo
        parametros = solicitar_parametros(metodo)
        proyecto.ejecutar_metodo(nombre_metodo, *parametros)
      else
        puts "El método #{nombre_metodo} no existe o no es válido."
      end

    when "10"
      puts "Saliendo del programa..."
      break

    else
      puts "Opción no válida, intenta nuevamente."
    end
  end
end

# Ejecutar main

main