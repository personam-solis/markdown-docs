# **Python Reference**

This is a quick reference to some uncommon and forgetable actions. There is very little context, and if you need to install a package, it is listed in another section.

- [**Python Reference**](#python-reference)
  - [**Templates**](#templates)
    - [**Argparse**](#argparse)
    - [**Logging**](#logging)
  - [**Standard Library**](#standard-library)
    - [Basic Things](#basic-things)
    - [Regex](#regex)
    - [Throw away var](#throw-away-var)
    - [**Ellipsis**](#ellipsis)
    - [**Searching with Lambda**](#searching-with-lambda)
    - [**__str__ and __repr__ class methods**](#str-and-repr-class-methods)
    - [**List Comprehension**](#list-comprehension)
    - [**Dictionary**](#dictionary)
    - [**Yield**](#yield)
    - [**Heap**](#heap)
    - [**Set**](#set)
    - [**Map**](#map)
    - [**Recursive Functions**](#recursive-functions)
    - [**Breadth-First Search**](#breadth-first-search)
    - [Playing with classes](#playing-with-classes)
    - [Decorators](#decorators)
    - [Multiprocessing](#multiprocessing)
  - [**Non-Standard Libraries**](#non-standard-libraries)


<br>

<br>

## **Templates**

### **Argparse**

```python
import argparse


def user_input() -> argparse.ArgumentParser:
    """
    Create a new argparse object if the program you want logging does not currently
    have an argparse object.

    Returns:
        parser_args (argparse.Namespace): The object created by the user input
    """

    parser = argparse. ArgumentParser (description="""
Debug and info logging enabled on this program
 """, formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--debug', action='store_true',
                        help='Run debug logging on the program')
    parser.add_argument('--info', action='store_true',
                        help='Run info logging on the program')
    parser_args = parser.parse_args()

    return parser


def main()
    # build argparse object
    parser = user_input()

    # If no input is given, print help and raise error
    if len(sys.argv()) == 1:
        parser.print_help()
        raise argparse.ArgumentError("NO ARGUMENT GIVEN!!!")

    # Process and store user arguments
    input_args = parser.parse_args()


if __name__ == '__main__':
    main()
```

<br>

### **Logging**

(Using argparse and wrapper)

```python
import logging
import argparse
from typing import Any, Callable


def add_log_arg(parser: argparse. ArgumentParser) -> argparse. ArgumentParser:
    """
    Simply add log arguments to a pre-made argument parser when imported.

    Args:
        parser (): An argument parser object before arguments are stored.
    Returns:
        parser.add_argument: Additional arguments of --info and --debug
    """
    parser.add_argument('--debug', action='store_true',
                        help='Run debug logging on the program')
    parser.add_argument('--info', action='store_true',
                        help='Run info logging on the program')
    return parser


def set_logging(parser_args: argparse.Namespace) -> argparse.Namespace:
    """
    Set the logging level based on the user's input

    Args:
        parse_args (argparse. Namespace): The object created by the user input
    Returns:
        logging (obj): Logging config object
    """
    if parser_args.debug:
        logging.basicConfig(level=logging.DEBUG,
            format="%(asctime)s | %(levelname)s | PID: %(process)d - %(message)s",
            datefmt="%Y%m%d %H:%M:%S")
        logging.getLogger()
        return logging
    elif parser_args.info:
        logging.basicConfig(level=logging.INFO,
            format="%(levelname)s: % (message)s")
        logging.getLogger()
        return logging
    else:
        logging.basicConfig(level=logging.WARNING)
        logging.getLogger()
        return logging


def log(func: Callable[..., Any]) -> Callable[..., Any]:
    """
    Decorator to create detailed logging for functions and classes
    """

    def wrapper (*args: Any, **kwargs: Any) -> Any: # Take in any args for the wrapper
        logging.info(f"Calling function: \'{func._name__}\'")
        process = func(*args, **kwargs) # Take any function from the input
        all_args = locals()
        logging.debug(f" {func._name_} was called with the arguments: \n{all_args}")
        logging.debug(f" {func._name_} defaults are: {func._defaults_}")
        logging.debug(f"Finished calling function: \'{func._name_}\'")

        return process # Return the function back

    return wrapper # Return the entire wrapper with function


def main()
    # build argparse object
    parser = user_input()
    add_log_arg(parser)

    # If no input is given, print help and raise error
    if len(sys.argv()) == 1:
        parser.print_help()
        raise argparse.ArgumentError("NO ARGUMENT GIVEN!!!")

    # Process and store user arguments
    input_args = set_logging(parser.parse_args())

```

<br>

<br>

## **Standard Library**

<br>

### Basic Things



<br>

<br>

### Regex

Helpful things to remember:

* Get the string that matched: `re.search(r'PATTERN', string).group()`

<br>

<br>

### Throw away var

If you want to loop something without having to worry about iteration, you can use the python "throw-away" variable `_` so the interpreter does not expect a value to exist or a variable to be used

```python
# Loop 10 times

for _ in range(10):
    do_a_thing()
```

<br>

<br>

### **Ellipsis**

In Python, `...` is a short-hand for the Ellipsis object part of the Ellipsis type which is a literal used for multiple things.

* When used in a function, it basically has the same effect as using the `pass` statement, except it can be treated as a value
    ```python
    def my_func():
        return ... # works

    def my_func():
        return pass # SyntaxError
    ```
    * `pass` is more used when the implementation is **supposed** to be empty, whereas `...` is used when the implementation is **missing**
* When used in slicing a multi-dimentional array, it selects all remaining dimentions:
    * `my_array[0, ..., 2]` takes the first index in the first dimention, third index in the last dimention, then all indicies in the dimentions in between.
* Other Libraries like fastapi and pydantic it is used when a value is required but you dont want python to set the default value
* Used in annotation to denote returning any number of a object. Useful when returning a tuple that you dont know the size
    ```python
    # Any number of integers
    def my_func() -> tuple[int, ...]: 
        return 1, 2, 3, 4
    ```

<br>

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

The `__repr__()` magic method returns a more information-rich, or official, string representation of an object. This method is called by the built-in `repr()` function. If possible, the string returned should be a valid Python expression that can be used to recreate the object. MAKE DETAILED!

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

### **Yield**

The yield statement suspends a function’s execution and sends a value back to the caller, but retains enough state to enable the function to resume where it left off. When the function resumes, it continues execution immediately after the last yield run. This allows its code to produce a series of values over time, rather than computing them at once and sending them back like a list.

```python
# generator to print even numbers
def print_even(test_list):
    for i in test_list:
        if i % 2 == 0:
            yield i
 
# initializing list
test_list = [1, 4, 5, 6, 7]
 
# printing even numbers
for j in print_even(test_list):
    print(j, end=" ")

# 4 6
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

While a set is mutable, you can use `frozenset()` to create an immutable set that can be iterated over, but will never change.

<br>

<br>

### **Map**

The built-in `map()` function allows you to execute a fucntion (and lambda) on an iterable; it then returns another iterable _object_ which can easily be turned into a list.

With map, you can also iterate over multiple iterables if the function takes that number of iterables

```python
def double(n):
    return n * 2

numbers = (1, 2, 3, 4, 5)
result = map(double, numbers)

print(list(result))
# [2, 4, 6, 8, 10]

#same result:
numbers = (1, 2, 3, 4, 5)
result = map(lambda x: x * 2, numbers)


#multiple iterables
def multiple(x, y):
    return x * y

numbers1 = (1, 2, 3, 4, 5)
numbers2 = (6, 7, 8, 9, 10)

result = list(map(multiple, numbers1, numbers2))
# [6, 14, 24, 36, 50]


# Make all strings in a list upper
result = list(map(str.upper, the_string))
```

<br>

<br>

### **Recursive Functions**

**memory:**
When any function is called from main(), the memory is allocated to it on the stack. A recursive function calls itself, the memory for a called function is allocated on top of memory allocated to the calling function and a different copy of local variables is created for each function call. When the base case is reached, the function returns its value to the function by whom it is called and memory is de-allocated and the process continues.

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

### Playing with classes

```python
class Reverse:
    """Iterator for looping over a sequence backwards."""
    def __init__(self, data):
        self.data = data
        self.index = len(data)

    def __iter__(self):
        return self

    def __next__(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.data[self.index]

rev = Reverse('spam')
iter(rev)
# <__main__.Reverse object at 0x00A1DB50>
for char in rev:
    print(char)

# m
# a
# p
# s
```

<br>

<br>

### Decorators

You can run code "in-between" a function by creating a decorator that has a wrapper function. 

Remember:
* Decorators "wrap" a function. so the first one listed is executed first, then the second one
* Decorators must take in any function argument, so it needs to be explicitly state it will

```python
from math import sqrt
import logging
from typing import Any, Callable
import functools

logging.basicConfig(level=logging.DEBUG,
    format="$(asctime)s | %(levelname)s | PID %(process)d - %(message)s",
    datefmt="%Y%m%d %H:%M:%S")

# Create the function that will be a decorator by taking in another function
# This gets logging information from a function
def log(func: Callable[..., Any]) -> Callable[..., Any]:
    @functools.wraps(func) # fix naming issues when getting function names in decorators
    def wrapper(*args: Any, **kwargs: Any) -> Any: # Take in any args for the wrapper
        logging.info(f"Calling: \'{func.__name__}\'")
        process = func(*args: Any, **kwargs: Any) # Take in any function
        all_args = locals()
        logging.debug(f"{func.__name__} was called with the arguments:\n{all_args}")
        logging.debug(f"{func.__name__} defaults are: {func.__defaults__}")
        logging.info(f"Finished calling function: \'{func.__name__}\'")
        return process # return the function back
    return wrapper

# How to get a prime but with the wrapper
@log
def is_prime(number: int) -> bool:
    if number < 2:
        return False
    for element in range(2, int(sqrt(number)) +1):
        if number % element == 0:
            return False
    return True
```

<br>

<br>

### Multiprocessing

Pools are the easiest way to do multiprocessing.

* DO NOT USE IF THE COST OF RUNNING THE FUNCTION EXCEEDS USING MULTITHREADDING
* By default each process has its own memory and interpreter so they CANNOT get variables from eachothers memory

```python
from multiprocessing import Pool

# multiprocessing.Pool([processes[, initializer[, initargs]]])
with Pool(processes=4) as pool:
    result = pool.map(funct1, ['arg1', 'arg2', 'arg3])


# You can also get results unordered (return as soon as result is ready)
with Pool(processes=4) as pool:
    # return an iterable object, but return it as soon as result is ready
    results = pool.imap_unordered(funct1, ['arg1', 'arg2', 'arg3])

    for i in results: # Calling the iterable is what blocks the process and when all elements are called, the program continues
        funct2(i)
```

## **Non-Standard Libraries**
