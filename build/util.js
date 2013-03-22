// Generated by CoffeeScript 1.4.0

/*
Clase de utilerias.
Dependencias de Librerias:
    jQuery
    jGrowl
    jQueryUI
@autor  Carlos Eduardo Fonseca Sandoval. cfonsecasan@gmail.com
@version 1.01.02
*/


(function() {

  this.util = (function() {

    function util() {}

    /*
        Convierte la cadena a su valor booleano.
        @param str   Cadena.
        @return      Valor boleano true o false.
    */


    util.cadenaABool = function(str) {
      if (!this.isNull(str)) {
        switch (str.toString().toLowerCase()) {
          case 'true':
          case '1':
            return true;
          case 'false':
          case '0':
            return false;
          default:
            Boolean(str);
        }
      }
      return false;
    };

    /*
        Verifica si es nulo un objeto
        @param obj   Objeto a verificar.
        @return      Devuelve true si es nulo o false en caso contrario
    */


    util.isNull = function(obj) {
      return typeof obj === 'undefined' || obj === null || !obj || obj === 'null';
    };

    /*
        Verifica si una cadena es nula o está vacía
        @param str   Cadena.
        @return      Devuelve true si es nulo o false en caso contrario
    */


    util.isNullOrEmpty = function(str) {
      return this.isNull(str) || str.length === 0;
    };

    /*
        Remplaza la subcadena {n} donde n>=0 apartir del arreglo de cadenas especificado
        @param str   Cadena que contiene los elementos a reemplazar.
        @param arr   Arreglo de elementos a reemplazar en la cadena.
        @return  Devuelve la cadena con los reemplazos correspondientes. Devuelve la cadena original si ésta es vacía o no existen elementos que reemplazar.
    */


    util.ponerStr = function(str, arr) {
      var i, regExp, _i, _ref;
      if (!this.isNullOrEmpty(str) && !this.isNull(arr) && arr.length > 0) {
        for (i = _i = 0, _ref = arr.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          regExp = new RegExp("\\{" + i + "\\}", "g");
          str = str.replace(regExp, arr[i]);
        }
      }
      return str;
    };

    /*
        Mensaje informativo por medio del plugin jGrowl.
        @param mensaje  Mensaje a presentar.
        @param error    Booleano que indica si el mensaje es de error o no.
        @param cabecera Texto a presentar en la cabecera del mensaje.
    */


    util.msg = function(mensaje, error, cabecera) {
      return $.jGrowl(mensaje, {
        header: this.isNullOrEmpty(cabecera) ? "INFO" : cabecera,
        theme: this.isNull(error) || !error ? 'GrowlExito' : 'GrowlError'
      });
    };

    /*
        Muestra bloqueo de un elemento con una imagen de cargando.
        @param elem     selector en donde se agregará la imagen.
        @àram msg       Mensaje a presentar
    */


    util.bloqueo = function(elem, msg) {
      return $(elem).block({
        message: '<img src="img/ajax-loader.gif" title="." alt="." /> ' + (msg || "Cargando...")
      });
    };

    /*
        Quita el bloqueo
        @param elem     selector en donde se quitará el bloqueo.
    */


    util.desbloqueo = function(elem) {
      return $(elem).unblock();
    };

    /*
        Convierte una cadena a fecha utilizando el datepicker de jQueryUI.
        @param strFecha Cadena de la fecha.
        @param formato Formato.
    */


    util.fecha = function(strFecha, formato) {
      if (this.isNullOrEmpty(strFecha)) {
        return null;
      }
      try {
        return $.datepicker.parseDate(formato, strFecha);
      } catch (e) {
        return null;
      }
    };

    /*
        Intenta convertir una entrada a un entero, si éste no es convertible, se asigna el valor por default especificado.
        @param val    Cadena o número a convertir.
        @return       Devuelve el número convertido, si no lo es, asigna el valor definido en @param-ref val.
    */


    util.tryParseInt = function(val, pValor) {
      var res;
      try {
        res = pValor;
        if (isNaN(res) || this.isNullOrEmpty(res)) {
          res = 0;
        }
        if (!isNaN(val) && !this.isNullOrEmpty(val)) {
          res = parseInt(val, 10);
        }
        if (!isNaN(res)) {
          return res;
        } else {
          return pValor;
        }
      } catch (e) {
        return pValor;
      }
    };

    /*
        Valida si una entrada entera tiene valor positivo.
        @param val    Cadena o número a validar.
        @return       Devuelve true si es positivo, de lo contrario false.
    */


    util.esPositivo = function(val) {
      try {
        return parseInt(val, 10) > 0;
      } catch (e) {
        return false;
      }
    };

    /*
        Agrega un dígito a la izquierda cuando sólo es un dígito.
        @param valor   Valor.
        @return        Devuelve la cadena con 2 dígitos.
    */


    util.agregaDigito = function(valor) {
      var digitos;
      digitos = 2;
      valor = !this.isNullOrEmpty(valor) ? '' + valor : '';
      if (digitos > valor.length) {
        valor = '0' + valor;
      }
      return valor;
    };

    /*
        Crea una mensaje de diálogo para eliminar.
        @param mensaje    Mensaje del cuadro de diálogo.
        @param titulo     Título del cuadro de diálogo.
        @param callback   Callback
        @param datos      Parámetros extra que recibirá el Callback como argumento.
    */


    util.dialogEliminar = function(mensaje, titulo, callback, datos) {
      var cn;
      cn = this.ponerStr('<div id="cnDialogo" title="{0}">{1}</div>', [titulo, mensaje]);
      $(cn).dialog({
        resizable: false,
        modal: true,
        buttons: {
          'Eliminar': function() {
            callback.call(this, datos);
            return $(this).dialog("close");
          },
          'Cancelar': function() {
            return $(this).dialog("close");
          }
        }
      });
      return true;
    };

    /*
        Obtiene el valor de un parámetro en el querystring.
        @param key    Nombre de la variable.
        @return Valor de la variable.
    */


    util.querystring = function(key) {
      var m, r, re;
      re = new RegExp('(?:\\?|&)' + key + '=(.*?)(?=&|$)', 'gi');
      r = [];
      while ((m = re.exec(document.location.search)) !== null) {
        r.push(m[1]);
      }
      return r;
    };

    /*
        Inserta un CSS en el head.
        @param archivo  Url del archivo
        @param id   (opcional) Id del archivo
    */


    util.insertaCss = function(archivo, id) {
      var head, link;
      if (document !== null) {
        head = document.getElementsByTagName('head')[0];
        link = document.createElement('link');
        link.rel = 'stylesheet';
        if (id !== null) {
          link.id = id;
        }
        link.type = 'text/css';
        link.href = archivo;
        link.media = 'screen';
        head.appendChild(link);
      }
      return true;
    };

    /*
        Inserta un js al final dentro del body o bien en un contenedor definido.
        @param archivo  Url del archivo.
        @param cn   (opcional) Id del contenedor en el que se pondrá el js.
        @param id   (opcional) Id del archivo
    */


    util.insertaJs = function(archivo, cn, id) {
      var contenedor, script;
      if (document !== null) {
        contenedor = cn !== null || cn.length > 0 ? document.body : document.getElementById(cn);
        script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = archivo;
        if (id !== null) {
          script.id = id;
        }
        contenedor.appendChild(script);
      }
      return true;
    };

    /*
        Convierte una cadena fecha de JSON en string en formato dd/mm/yyyy
        @param valor   Fecha en string.
        @return Fecha en string.
    */


    util.convierteFechaJson = function(valor) {
      var fecha, mes;
      fecha = new Date(parseInt(valor.substr(6)));
      mes = this.agregaDigito(fecha.getMonth() + 1);
      return this.agregaDigito(fecha.getDate()) + '/' + mes + '/' + fecha.getFullYear();
    };

    return util;

  })();

}).call(this);
