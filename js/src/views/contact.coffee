root = window ? global
Dgroupe = root.Dgroupe

# Contact Form View

class Dgroupe.Views.contact extends Backbone.View
  el: '#mainContact'

  initialize: (options)->
    @$alert =  $ @$el.parent().find('.alert')
    @formUrl = @$el.attr( 'action' )

  events:
    'submit': 'contactHandler'
    'change input.name': 'getToken'

  getToken: (e)=>
    if @formUrl isnt ''
      val = $(e.currentTarget).val()
      if val isnt ''
        $.get @formUrl, {'action':'getToken', 'tokenString': val}, (response)=>
          console.log response.token
          @setTokenField(response.token)

  setTokenField:(token)->
    console.log 'setting token to ' + token
    $tokenInput= $( @$el.find('input[name="token"]') )
    $tokenInput.val(token)
    this

  contactHandler: (e)=>
    e.preventDefault()
    if @formUrl isnt ''
      @sendForm @$el.serialize()

  sendForm: (data)->
    $.ajax
      type: 'POST'
      url: @formUrl
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
