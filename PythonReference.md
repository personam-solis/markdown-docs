# **Python Reference**

This is a quick reference to some uncommon and forgetable actions. There is very little context, and if you need to install a package, it is listed in another section.

<br>

<br>

## **Standard Library**

<br>

### **Searching with Lambda**

You can use lambda to perform a custom sort; this works by the lambda performing an operation on each _element_.This applies to both the `sorted` library and the `.sort()` module.

Remember, the _sort_ is what is actually doing the sorting, the lambda is _what_ to sort by

```python
words = ["apple", "banana", "cherry", "date", "elderberry"]
words.sort(key=lambda x: len(x)) # Sort by the length of the element


people = [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 30},
    {"name": "Charlie", "age": 20},
]
people.sort(key=lambda x: -x["age"]) # Sort by the key "age" in reverse


logs = [
  "sfh sfsh shf sdfh",
  "sdf gsdf ggrd",
  "sdf gfshds  hs h",
  "sdf hshs dshf dsh",
  "sfh ss hs sdh"
]
# Sort the logs by from element 1 on, THEN if they are the same sort by element 0
logs.sort(key=lambda x:(x.split()[1:], x.split()[0]))
```

<br>

<br>

## **__str__ and __repr__ class methods**

The `__str__()` method returns a human-readable, or informal, string representation of an object. This method is called by the built-in `print()`, `str()`, and `format()` functions.

The `__repr__()` method returns a more information-rich, or official, string representation of an object. This method is called by the built-in `repr()` function. If possible, the string returned should be a valid Python expression that can be used to recreate the object

```python
mydate = datetime.datetime.now()

print("__str__() string: ", mydate.__str__())
# __str__() string:  2023-01-27 09:50:37.429078
print("str() string: ", str(mydate))
# str() string:  2023-01-27 09:50:37.429078

print("__repr__() string: ", mydate.__repr__())
# __repr__() string:  datetime.datetime(2023, 1, 27, 9, 50, 37, 429078)
print("repr() string: ", repr(mydate))
# repr() string:  datetime.datetime(2023, 1, 27, 9, 50, 37, 429078)


class Ocean:
    def __init__(self, sea_creature_name, sea_creature_age):
        self.name = sea_creature_name
        self.age = sea_creature_age
    def __str__(self):
        return f'The creature type is {self.name} and the age is {self.age}'
    def __repr__(self):
        return f'Ocean(\'{self.name}\', {self.age})'

c = Ocean('Jellyfish', 5)
print(str(c))
# The creature type is Jellyfish and the age is 5
print(repr(c))
# Ocean('Jellyfish', 5)
```

<br>

<br>

## **Non-Standard Libraries**
