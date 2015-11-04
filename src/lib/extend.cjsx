module.exports = (base, objects...) ->
  instance = Object.create base
  for object in objects
    for own key, value of object
      instance[key] = value
  instance
