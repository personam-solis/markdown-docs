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

### **__str__ and __repr__ class methods**

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

### **List Comprehension**

A list comp is a way to quickly make a list based on some action

list = [ `expression(element)` _for_ `element` _in_ `oldList` _if_ `condition` ] 

```python
[i for i in range(11) if i % 2 == 0] # Even Numbers

[i*10 for i in range(1, 6)] # "tens": 10, 20, 30, 40

[num for num in range(100) if num % 5 == 0 if num % 10 == 0] # "tens" up to 100
```

<br>

<br>

### **Dictionary**

```python
Dict = {'Name': 'Geeks', 1: [1, 2, 3, 4]}

# accessing a element using key
print("Accessing a element using key:")
print(Dict['Name'])
 
# accessing a element using get()
# method
print("Accessing a element using get:")
print(Dict.get(1))
 
# creation using Dictionary comprehension
myDict = {x: x**2 for x in [1,2,3,4,5]}
print(myDict)
```

<br>

<br>

### **Heap**

Heaps are a way to create and manage a queue. Queues help manage an array in the order that you want based on setting a predetermined priority attribute.

* An element with high priority is dequeued before an element with low priority.
* If two elements have the same priority, they are served according to their order in the queue.

`heapq` module in Python provides the heap data structure that is mainly used to represent a priority queue. The property of this data structure is that it always gives the smallest element (min heap) whenever the element is _popped_. **Whenever elements are pushed or popped, heap structure is maintained.** The `heap[0]` element also returns the smallest element each time. It supports the extraction and insertion of the smallest element in the $O\log_{n}$ times.

Generally, Heaps can be of two types:

* **Max-Heap:** In a Max-Heap the key present at the root node must be greatest among the keys present at all of it’s children. The same property must be recursively true for all sub-trees in that Binary Tree.
* **Min-Heap:** In a Min-Heap the key present at the root node must be minimum among the keys present at all of it’s children. The same property must be recursively true for all sub-trees in that Binary Tree

```python
import heapq

li = [5, 7, 9, 1, 3]

# using heapify to convert list into heap
heapq.heapify(li)
print (list(li))
# [1, 3, 9, 7, 5]

# using heappush() to push elements into heap
heapq.heappush(li, 4)
print (list(li))
# [1, 3, 4, 7, 5, 9]

# using heappop() to pop smallest element
print (heapq.heappop(li))
# 1
```

<br>

<br>

### **Set**

Python set is a mutable collection of data that does not allow any duplication. Sets are basically used to include membership testing and eliminating duplicate entries.

```python
chicken = set([1, 2, 3, 4, 'chick', 5, 4, 3, 'chick'])
# {1, 2, 3, 4, 'chick', 5}

# Convert list into a set to remove duplicates if you dont care about it staying in order
chick = [1, 2, 3, 4, 5, 6, 4, 3, 2]
chick = set(chick)
```

<br>

<br>

### **Breadth-First Search**

Search algorithm that looks at neighboring nodes in a graph, and only visits a node once.

Take Array:

```python
graph = [
    [1, 0, 1, 1, 0, 0],
    [1, 1, 0, 1, 0, 0],
    [0, 1, 1, 0, 0, 1],
    [0, 0, 0, 1, 0, 1]
]
```

Calculate how many nodes are a group of 1's. AKA island problem

(look at the [jupyter notebook](Python/breadth_first_search.ipynb))

## **Non-Standard Libraries**
