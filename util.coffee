###
Clase de utilerias.
Dependencias de Librerias:
    jQuery
    jGrowl
    jQueryUI
@autor  Carlos Eduardo Fonseca Sandoval. cfonsecasan@gmail.com
@version 1.01.02
###
class @util
    ###
    Convierte la cadena a su valor booleano.
    @param str   Cadena.
    @return      Valor boleano true o false.
    ###
    @cadenaABool: (str) ->
        if not this.isNull str
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
        typeof obj is 'undefined' or obj is null or not obj
    ###
    Verifica si una cadena es nula o está vacía
    @param str   Cadena.
    @return      Devuelve true si es nulo o false en caso contrario
    ###
    @isNullOrEmpty: (str) ->
        this.isNull(str) or str.length is 0
    ###
    Remplaza la subcadena {n} donde n>=0 apartir del arreglo de cadenas especificado
    @param str   Cadena que contiene los elementos a reemplazar.
    @param arr   Arreglo de elementos a reemplazar en la cadena.
    @return  Devuelve la cadena con los reemplazos correspondientes. Devuelve la cadena original si ésta es vacía o no existen elementos que reemplazar.
    ###
    @ponerStr: (str, arr) ->
        if not this.isNullOrEmpty(str) and not this.isNull(arr) and arr.length > 0
            for i in [0..arr.length]
                regExp = new RegExp("\\{" + i + "\\}", "g")
                str = str.replace(regExp, arr[i])
        str
    ###
    Mensaje informativo por medio del plugin jGrowl.
    @param mensaje  Mensaje a presentar.
    @param error    Booleano que indica si el mensaje es de error o no.
    @param cabecera Texto a presentar en la cabecera del mensaje.
    ###
    @msg: (mensaje, error, cabecera) ->
        $.jGrowl mensaje,
                header: if this.isNullOrEmpty(cabecera) then "INFO" else cabecera
                theme: if this.isNull(error) or not error then 'GrowlExito' else 'GrowlError'
    ###
    Muestra bloqueo de un elemento con una imagen de cargando.
    @param elem     selector en donde se agregará la imagen.
    @àram msg       Mensaje a presentar
    ###
    @bloqueo: (elem, msg) ->
        $(elem).block message: '<img src="img/ajax-loader.gif" title="." alt="." /> ' + (msg || "Cargando...")
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
        if this.isNullOrEmpty strFecha
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
            if isNaN(res) or this.isNullOrEmpty(res)
                res = 0

            if not isNaN(val) and not this.isNullOrEmpty(val)
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
    Agrega un dígito a la izquierda cuando sólo es un dígito.
    @param valor   Valor.
    @return        Devuelve la cadena con 2 dígitos.
    ###
    @agregaDigito: (valor) ->
        digitos = 2
        valor = if not this.isNullOrEmpty(valor) then ''+valor else ''
        if digitos > valor.length
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
        cn = this.ponerStr '<div id="cnDialogo" title="{0}">{1}</div>',
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