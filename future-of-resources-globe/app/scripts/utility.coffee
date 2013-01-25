# Miscellaneous utility functions

digits_commas_regex = /(\d)(?=(\d\d\d)+(?!\d))/g

FTI.util = {

  getStyledPrice: (num) ->
    # Returns the number of dollars in FT style.
    if num >= 1e9
      '$' + @addCommasToNumber (Math.round(num / 1e8) / 10)  + 'bn'
    else
      '$' + @addCommasToNumber (Math.round(num / 1e5) / 10) + 'm'

  addCommasToNumber: (num) ->
    (num + '').replace(digits_commas_regex, "$1,")

}
