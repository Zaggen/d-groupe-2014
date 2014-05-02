root = window ? global

$ = root.jQuery

root.template = (id)->
  _.template( $('#' + id).html() )

root.removeTrailingSlash = (route)->
  index = route.length - 1
  if route.charAt(index) is '/'
    route = route.substring(0, index)
  else
    route

baseFolder =  window.location.pathname.replace('/','').split('/')[0] # Also used as the backbone history root

class root.Dgroupe
  @Models: {}
  @Collections: {}
  @Views: {}
  @Routers: {}
  @helpers:
    baseFolder: baseFolder # Also used as the backbone history root
    rootUrl: window.location.protocol + "//" + window.location.host + "/" + baseFolder;


# Used to filter each ajax json request for the backbone models
$.ajaxPrefilter (options)->
  options.url = Dgroupe.helpers.rootUrl + options.url
  false

#Dgroupe.helpers.rootUrl