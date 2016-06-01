Classes = require './Classes'

shinyClasses = (class_sets...) -> new Classes(class_sets...)


shinyClasses.Classes = Classes
module.exports = shinyClasses

