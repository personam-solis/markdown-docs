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

## **Non-Standard Libraries**
