##########################################################
##########################################################
##                  ___                                 ##
##                 / _ \                                ##
##                / /_\ \_ __  _ __                     ##
##                |  _  | '_ \| '_ \                    ##
##                | | | | |_) | |_) |                   ##
##                \_| |_/ .__/| .__/                    ##
##                      | |   | |                       ##
##                      |_|   |_|                       ##
##                                                      ##
##########################################################
##########################################################

## Libs ##
#= require jquery
#= require parsleyjs
#= require bootstrap
#= require data-confirm-modal

##########################################################
##########################################################

## Flash ##
## Allows us to close the flash alerts on command ##
$(document).on "click", "flash > div", (e) ->

  ## Fade Out ##
  ## After this, remove from the DOM ##
  $(this).animate { height: 0, opacity: 0 }, 50, ->
    $(this).remove()

##########################################################
##########################################################

$(document).on "click", "[data-confirm]", (e) ->
  e.preventDefault()
  return $(this).confirmModal()

## Ready ##
## Allows us to bind with DOM ##
$(document).ready ->

  ## Modal ##
  ## Confirmation Modal ##
  ## https://github.com/ifad/data-confirm-modal#without-rails-with-data-attributes-example-b3-example-b4 ##


##########################################################
##########################################################
