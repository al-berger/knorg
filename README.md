# Knorg
### Personal Knowledge Organizer

## Usage

```
tree3 <FULL_PATH_TO>/knorg.td
```

## Facts

Facts are the basic building blocks of which the knowledge database consists.
A fact asserts that some object has a certain relation to some other object or
to some information. Therefore, a record about fact contains three parts: "object",
"relation", "info". A schematic example of a list of fact records:

```
OBJECT  |  RELATION  |  INFO
-----------------------------
Wheel      part of      Car
some car     make      "Toyota"
SUV        type of      Car
some car     type       SUV
Car           is       Vehicle
```

Every object in fact records must be somehow uniquely identifiable in
order to avoid ambiguities like:

```
OBJECT  | RELATION |      INFO
-------------------------------------------------------------
square       is     geometric figure
square       is     product of multiplying a number by itself
```

There are two ways to disambiguate object names. The first is to use only unique names
for objects. With this way, the above incosistency can be resolved by renaming the
"square" objects with different names: `square (geom.)` and `square (math.)`. 
In this way, new similarly named objects can be added without
ambiguity: `"square (urban.) is an open space at streets intersection"`, 
`"square (draw.) is an instrument for drawing right angles"`, etc.

The second way to distinguish objects with similar names is through some additional
information, which clarifies which object the fact is ascribed to. The facts are stored in
fact records files in the following format:

```
# <OBJECT>

* <RELATION>
<INFO>

* <RELATION>
<INFO>

...
```

Objects are marked with `#`, relations are marked with `*`, and the information
ascribed to the object follows right after the relation.

Such structure makes it possible to have two objects in the knowledge base that have the same names, but are different entities. When we have two objects with identical names, we  add another relation to both objects, which stores the information about the difference between the objects and mark this relation as "identifying" by enclosing the relation name in square brackets. For differentiating the "square" objects, we can add the information about the knowledge domain (or topic) the object belongs to:

_file1.km_:

```
# square

* [Topic]
Geometry

* Definition
A polygon having four equal sides and four equal angles.
```

_file2.km_:

```
# square

* [Topic]
Mathematics

* Definition
The product obtained when a number or quantity is multiplied by itself.

```

## Records file format

A records file has the following scheme:

```
records_file := fact ["\n" fact]*
fact := object_field "\n" relation_field "\n" content_field
object_field := "# " OBJECT_NAME
relation_field := "* " RELATION
content_field := ( OBJECT_NAME | STRING_LITERAL )
```

`OBJECT_NAME` can contain 1 - 256 characters; reserved character: '/'.
`RELATION` can contain 1 - 256 characters; reserved characters: '[', ']'.

If consecutive facts relate in the object field to the same object, then it's
sufficient to put the object field only for the first fact:

```
object_field
relation_field
content_field

relation_field
content_field

...
```
