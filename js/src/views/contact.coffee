root = window ? global
Dgroupe = root.Dgroupe

# Contact Form View

class Dgroupe.Views.contact extends Backbone.View
  el: '#mainContact'

  initialize: ->
    @$alert =  $ @$el.parent().find('.alert')

  events:
    'submit': 'contactHandler'

  contactHandler: (e)=>
    e.preventDefault()
    @sendForm @$el.serialize()

  sendForm: (data)->
    $.ajax
      type: "POST"
      url: @$el.attr( 'action' )
      data: data

      success: ( response )=>
        @$el.before @setMsgAlert(response)
        if response.status is 'success'
          @$el.addClass 'setOpacityTenPercent'
          @$el.find('#contactSubmit').remove()

      error: =>
        msgObj =
          status: 'failed'
          title: 'Error de conexión'
          description: 'Hubo un problema al intenta enviar tu mensaje, intentalo mas tarde'

        @$el.before @setMsgAlert(msgObj)

  setMsgAlert: (response)->
    console.log response
    alertClass = 'alert ' + if response.status is 'success' then 'alertSuccess' else 'alertDanger'
    @$alert
    .removeClass()
    .addClass(alertClass)
    .html('<strong>' + response.title + '</strong> ' + response.description)
