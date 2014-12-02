###
Clase de utilerias.
Dependencias de Librerias:
    jQuery
    jGrowl
    BlockUI
    jQueryUI
@autor  Carlos Eduardo Fonseca Sandoval. cfonsecasan@gmail.com
@version 1.04.11
###
class @util
    ###
    Convierte la cadena a su valor booleano.
    @param str   Cadena.
    @return      Valor boleano true o false.
    ###
    @cadenaABool: (str) ->
        if not @isNull str
            switch str.toString().toLowerCase()
                when 'true', '1'
                    return true
                when 'false', '0'
                    return false
                else Boolean(str)
        false
    ###
    Verifica si es nulo un objeto
    @param obj   Objeto a verificar.
    @return      Devuelve true si es nulo o false en caso contrario
    ###
    @isNull: (obj) ->
        typeof obj is 'undefined' or obj is null or not obj or obj is 'null'
    ###
    Verifica si una cadena es nula o está vacía
    @param str   Cadena.
    @return      Devuelve true si es nulo o false en caso contrario
    ###
    @isNullOrEmpty: (str) ->
        @isNull(str) or str.length is 0
    ###
    Remplaza la subcadena {n} donde n>=0 apartir del arreglo de cadenas especificado
    @param str   Cadena que contiene los elementos a reemplazar.
    @param arr   Arreglo de elementos a reemplazar en la cadena.
    @return  Devuelve la cadena con los reemplazos correspondientes. Devuelve la cadena original si ésta es vacía o no existen elementos que reemplazar.
    ###
    @ponerStrByArr: (str, arr) ->
        if not @isNullOrEmpty(str) and not @isNull(arr) and arr.length > 0
            for i in [0..arr.length]
                regExp = new RegExp("\\{" + i + "\\}", "g")
                str = str.replace regExp, arr[i]
        str
    ###
    Verifica si un valor es del tipo Array
    @param value Valor
    @return Devuelve true si lo es, false en caso contrario
    ###
    @typeIsArray: (value) ->
        value and
            typeof value is 'object' and
            value instanceof Array and
            typeof value.length is 'number' and
            typeof value.splice is 'function' and
            not ( value.propertyIsEnumerable 'length' )
    ###
    Remplaza la subcadena {n} donde n es el nombre de la propiedad dentro del objeto obj (por ejemplo {foo} y {bar}) o 
    donde n>=0 apartir del arreglo de cadenas especificado (por ejemplo {0}, {1}).
    @param str    Cadena que contiene los elementos a reemplazar.
    @param obj    Arreglo de elementos a reemplazar en la cadena.
    @param parent (No especificado por el usuario) Indica el nombre del elemento padre que lo contiene, en caso de que el objeto obj sea más complejo.
        Por ejemplo al querer imprimir un dato como {Alumno.Nombre}
    @return  Devuelve la cadena con los reemplazos correspondientes. Devuelve la cadena original si ésta es vacía o no existen elementos que reemplazar.
    ###
    @ponerStr: (str, obj, parent = '') ->
        if not @isNullOrEmpty(str) and not @isNull(obj)
            
            if @typeIsArray(obj)
                str = @ponerStrByArr str, obj
            else if typeof obj is 'object'
                for key, val of obj
                    if typeof val is 'object'
                        str = @ponerStr str, val, (if parent.length > 0 then parent else '') + key + '.'
                    else
                        regExp = new RegExp("\\{" + (parent + key) + "\\}", "g")
                        str = str.replace regExp, val
            
        str
    ###
    Mensaje informativo por medio del plugin jGrowl.
    @param mensaje  Mensaje a presentar.
    @param error    Booleano que indica si el mensaje es de error o no.
    @param cabecera Texto a presentar en la cabecera del mensaje.
    ###
    @msg: (mensaje, error, cabecera) ->
        $.jGrowl mensaje,
                header: if @isNullOrEmpty(cabecera) then "INFO" else cabecera
                theme: if @isNull(error) or not error then 'GrowlExito' else 'GrowlError'
    ###
    Muestra bloqueo de un elemento con una imagen de cargando. (Requiere de BlockUI)
    @param elem     selector en donde se agregará la imagen.
    @param msg      (Opcional) Mensaje a presentar
    @param rutaImg  (Opcional) Ruta de la imagen de carga. De manera predeterminada es img/ajax-loader.gif
    ###
    @bloqueo: (elem, msg, rutaImg) ->
        rutaImg = rutaImg or'Content/img/ajax-loader.gif'
        $(elem).block message: '<img src="' + rutaImg + '" title="." alt="." /> ' + (msg || "Cargando...")
    ###
    Quita el bloqueo
    @param elem     selector en donde se quitará el bloqueo.
    ###
    @desbloqueo: (elem) ->
         $(elem).unblock()
    ###
    Convierte una cadena a fecha utilizando el datepicker de jQueryUI.
    @param strFecha Cadena de la fecha.
    @param formato Formato.
    ###
    @fecha: (strFecha, formato) ->
        if @isNullOrEmpty strFecha
            return null
        try
            $.datepicker.parseDate(formato, strFecha)
        catch e
            null
    ###
    Intenta convertir una entrada a un entero, si éste no es convertible, se asigna el valor por default especificado.
    @param val    Cadena o número a convertir.
    @return       Devuelve el número convertido, si no lo es, asigna el valor definido en @param-ref val.
    ###
    @tryParseInt: (val, pValor) ->
        try
            res = pValor
            if isNaN(res) or @isNullOrEmpty(res)
                res = 0

            if not isNaN(val) and not @isNullOrEmpty(val)
                res = parseInt(val, 10)

            if not isNaN(res) then res else pValor
        catch e
            pValor
    ###
    Valida si una entrada entera tiene valor positivo.
    @param val    Cadena o número a validar.
    @return       Devuelve true si es positivo, de lo contrario false.
    ###
    @esPositivo:  (val) ->
        try
            parseInt(val, 10) > 0
        catch e
            false
    ###
    Agrega ceros a la izquierda de un número.
    @param valor    Valor.
    @param digitos  (Opcional) Número de digitos que tendrá el número incluyendo los ceros.
    @return        Devuelve la cadena.
    ###
    @agregaDigito: (valor, digitos) ->
        digitos = digitos || 2

        valor = '' + valor
        
        if (valor.length >= digitos)
            return valor

        max = (digitos - valor.length)
        while (max--)
            valor = '0' + valor
        valor
    ###
    Crea una mensaje de diálogo para eliminar.
    @param mensaje    Mensaje del cuadro de diálogo.
    @param titulo     Título del cuadro de diálogo.
    @param callback   Callback
    @param datos      Parámetros extra que recibirá el Callback como argumento.
    ###
    @dialogEliminar: (mensaje, titulo, callback, datos) ->
        cn = @ponerStr '<div id="cnDialogo" title="{0}">{1}</div>',
                           [titulo, mensaje]
        $(cn).dialog {resizable: false, modal: true, buttons:
            'Eliminar': () ->
                callback.call(this, datos)
                $( this ).dialog( "close" )
            'Cancelar': () ->
                $( this ).dialog( "close" )}
        true
    ###
    Obtiene el valor de un parámetro en el querystring.
    @param key    Nombre de la variable.
    @return Valor de la variable.
    ###
    @querystring:  (key) ->
        re = new RegExp('(?:\\?|&)'+key+'=(.*?)(?=&|$)','gi')
        r = []
        while (m = re.exec document.location.search) isnt null
            r.push m[1]
        r

    ###
    Inserta un CSS en el head.
    @param archivo  Url del archivo
    @param id   (opcional) Id del archivo
    ###
    @insertaCss: (archivo, id) ->
        if document isnt null
            head = document.getElementsByTagName('head')[0]
            link = document.createElement('link')
            link.rel  = 'stylesheet'
            link.id = id if id isnt null
            link.type = 'text/css'
            link.href = archivo
            link.media = 'screen'
            head.appendChild link
        true

    ###
    Inserta un js al final dentro del body o bien en un contenedor definido.
    @param archivo  Url del archivo.
    @param cn   (opcional) Id del contenedor en el que se pondrá el js.
    @param id   (opcional) Id del archivo
    ###
    @insertaJs: (archivo, cn, id) ->
        if document isnt null
            contenedor = if cn isnt null or cn.length  > 0 then document.body else document.getElementById cn
            script = document.createElement('script')
            script.type = 'text/javascript'
            script.src = archivo
            script.id = id if id isnt null
            contenedor.appendChild script
        true

    ###
    Convierte una cadena fecha de JSON en string en formato dd/mm/yyyy
    @param valor      Fecha en string.
    @param quitarHora Define si se desea quitar la hora (predeterminado) de la fecha.
    @return Fecha en string.
    ###
    @convierteFechaJson: (valor, quitarHora = true) ->
        fecha = new Date(parseInt(valor.substr(6)))
        mes = @agregaDigito(fecha.getMonth()+1)
        tiempo = 'AM'
        hora = 0
        minutos = 0

        if not quitarHora
            hora = fecha.getHours()
            minutos = fecha.getMinutes() + ''

            if (hora >= 12) 
                tiempo = 'PM'

            if hora > 12
                hora -= 12

            else if hora == 0
                hora = 12

            if minutos.length == 1
                minutos = '0' + minutos

        return @ponerStr '{0}/{1}/{2} {3}', [@agregaDigito(fecha.getDate()), mes, fecha.getFullYear(), if quitarHora then '' else @ponerStr '{0}:{1} {2}', [hora, minutos, tiempo]]

    ###
    Agrega separadores de miles, etc a los números.
    @param num          Número
    @param sinDecimales (Opcional) True si no desean agregar decimales
    @return Número formateado.
    ###
    @formatoNumero: (num, sinDecimales) ->
        sinDecimales = sinDecimales || false
        num = if sinDecimales then parseInt(num) else parseFloat(num).toFixed(2)
        num += ''
        x = num.split('.')
        x1 = x[0]
        x2 = if x.length > 1 then '.' + x[1] else ''
        rgx = /(\d+)(\d{3})/
        while rgx.test(x1)
            x1 = x1.replace(rgx, '$1' + ',' + '$2')

        x1 + x2

    ###
    Extiende las propiedades de un objeto simple.
    @param defaults         Objecto base.
    @param objSecundario    Objecto secundario.
    @return Objeto original extendido.
    ###
    @extend: (defaults, objSecundario) ->
        defaults = defaults || {}
        objSecundario = objSecundario || {}
        
        #Si el objSecundario es una instancia de un Array y no tiene elementos, lo asignamos
        defaults = objSecundario if objSecundario instanceof Array and objSecundario.length is 0

        for prop of objSecundario
            if typeof objSecundario[prop] is 'object'
                defaults[prop] = @extend defaults[prop], objSecundario[prop]
            else
                defaults[prop] = objSecundario[prop]
        defaults


    ###
    Verifica si un elemento tiene una clase
    @param el       Elemento html
    @param clase    Nombre de la clase a buscar
    @return true si la encontró, de lo contrario false.
    ###
    @hasClass: (el, clase) ->
            new RegExp('(\\s|^)'+clase+'(\\s|$)').test(el.className)

    ###
    Agrega una clase al elemento html
    @param el       Elemento html
    @param clase    Nombre de la clase a agregar
    ###
    @addClass: (el, clase)->
        if not @hasClass(el, clase)
            el.className += (if el.className then ' ' else '') + clase

    ###
    Quita una clase al elemento html
    @param el       Elemento html
    @param clase    Nombre de la clase a quitar
    ###
    @removeClass: (el, clase) ->
        if @hasClass(el, clase)
            el.className = el.className.replace(new RegExp('(\\s|^)'+clase+'(\\s|$)'),' ').replace(/^\s+|\s+$/g, '')

    ###
    Convierte los caracteres especiales de una cadena a su correspondiente Ascii
    @param str      Cadena que contiene el texto
    @return Cadena ya convertida.
    ###
    @htmlEncode: (str) ->
        i = str.length
        aRet = []

        while i--
            iC = str[i].charCodeAt()
            aRet[i] = if iC < 65 or iC > 127 or (iC>90 and iC<97) then '&#'+iC+';' else str[i]
        aRet.join('') 
    

    ###
    Genera un GUID simple
    @return GUID de 4 caracteres.
    ###
    @simpleGuid: () ->
        S4 = () ->
            (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1)
        (S4()).toString()

