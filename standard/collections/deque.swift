/* The interface is nearly identical since both Array and Deque implement the same collection protocols. So why use a Deque over an Array? The tradeoffs are hard to see until you consider time complexity.

A Deque is a double-ended queue. Therefore, Deque optimizes for modifications from both the front and the back of the collection. Unlike Array, inserting or removing an element from the front of a Deque is a cheap O(1) operation.

In programming, everything is about tradeoffs. For Deque, it’s about improving modifications in the front for the cost of slightly degraded performance on everything else. If your app requires frequent modifications to the front of a collection, a Deque will perform much better than an Array. */