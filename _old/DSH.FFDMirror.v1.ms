clearListener()
ffd = $.modifiers[1]

ffdPointCount = getDimensions ffd

animateAll ffd

rightCP = ("control_point_" + ((ffdPointCount.x as Integer) as String))
c = getPropertyController  ffd rightCP

oldV = (addnewkey c 0f).value


newV = [oldV.x * -1 + 1, oldV.y, oldV.z]

c = getPropertyController  ffd "control_point_1"
k = addnewkey c 0f
k.value = newV


