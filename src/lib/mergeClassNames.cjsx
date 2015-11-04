module.exports = (styles...) ->
  classNames = {}
  for style in styles
    if typeof style is 'string'
      style = style.split /\s+/g
    if Array.isArray style
      for className in style when className
        classNames[className] = yes
    else if style and typeof style is 'object'
      for own className, value of style
        if (className is 'className') and typeof value is 'string'
          for className in value.split /\s+/g
            classNames[className] = yes
        else if value is yes
          classNames[className] = yes
  delete classNames['']
  Object.keys classNames
    .join ' '
