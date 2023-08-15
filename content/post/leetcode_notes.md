+++
title = "WIP: 刷题时永远记不住的东西"
date = 2023-08-15
lastmod = 2023-08-15T20:31:00+08:00
tags = ["算法", [",", "数据结构"], [",", "刷题"]]
draft = false
katex = true
+++

> 刷题时不可能刷题的，这辈子都不可能刷题的。
>
> 学校里个个都是人才，说话也好听，我超喜欢在里面的。


## 快排 {#快排}



总是背不下来的快排。

我已经写了一篇快排的笔记了，现在就在这里也记录一下吧。

一个最简单的快排算法真的不需要多少代码。需要记忆的内容也只有几个，我们跟着代码来一起记忆。

```cpp
// 1. [l, r] 记住我们的代码是左闭右闭的区间
void qsort(vector<int>& a, int l, int r) {
    if(l >= r) return; // 2. 边界条件一定要判断
    int pivot = a[l], ll = l, rr = r; // 3. pivot 如果想写的简单一点就最左边这个数就可以，不过记住是 a[l] 不是 a[0]!
    while(ll < rr) { // 4. 这个循环条件必不可少，决定了能否找到 pivot 真正的位置
        // 5. while 循环中的 ll < rr 作为先制条件不能删除！这可以保证 ll 永远不会超过 rr，使得 swap 可以放心进行
        // 6. rr-- 的 while *必须* 在 ll++ 的循环之前！否则对于像是 [1, 2, 2, 2, 2] 的数组，ll 与 rr 不能正确地找到自己的位置
        // （也就是一个元素本身就是最小的数，我们必须保证两个指针在最左侧相遇，所以为了防止这种情况，ll 必须晚于 rr 移动）
        while(ll < rr && a[rr] >= pivot) rr--;
        while(ll < rr && a[ll] <= pivot) ll++;
        swap(a[ll], a[rr]); // 7. swap ，不难理解
    }
    swap(a[l], a[ll]); // 8. ll 与 rr 必然都在 pivot 该在的地方，这时候交换 pivot(a[l]) 与 ll 的位置
    qsort(a, l, ll - 1); // 9. 再做两次 qsort 进行分治，ll 位置已经不需要再进行排序了，所以 ll - 1, 与 ll + 1 就很合理
    qsort(a, ll + 1, r);
}
```

最关键的几个：

1.  左闭右闭
2.  pivot = a[l]
3.  while(ll &lt; rr)
4.  先 rr-- 再 ll++
5.  里面 swap ll, rr，外面 swap a[l], a[ll]
6.  分治


## 二分搜索 {#二分搜索}




### 基础算法 {#基础算法}

一个最简单的实现如下：

```cpp
int search(vector<int>& nums, int target) {
    int left = 0, right = nums.size() - 1;
    while(left <= right){
        int mid = (right - left) / 2 + left;
        int num = nums[mid];
        if (num == target) {
            return mid;
        } else if (num > target) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return -1;
}
```

这个是 leetcode 的样例代码，我更喜欢左闭右开的写法：

```cpp
// [l, r)
// 如果存在则返回下标
// 如果不存在则返回 -1
int bsearch(vector<int>& a, int num) {
    int l = 0, r = a.size();
    int mid = (l + r) / 2;
    while(l < r) {
        mid = (l + r) / 2;
        if(a[mid] > num) {
            r = mid;
        } else if(a[mid] < num) {
            l = mid + 1;
        } else if(a[mid] == num) {
            return mid;
        }
    }
    return -1;
}
```

不过左闭右开的写法很容易写出错误出来，还是老老实实按照样例程序记忆吧。


### 若干特例 {#若干特例}


#### 不超过、不小于 {#不超过-不小于}

有两个非常经典的问题：

1.  找到有序数组中不超过特定数的最大数
2.  找到有序数组中不小于特定数的最小数

这两个问题使用样例代码非常简单

当 search 函数返回 -1 的时候，它的 left 和 right 一定在搜索数的两端，left 在比搜索数大的一端，right 在比搜索数小的一端。这个特性不会因为数组中的重复元素而发生变化。但是如果使用左闭右开的方法的话，就一定会出现问题（所以一定要背标准答案啊！

```txt
[1, 4, 4, ]
bsearch end with: l 1, r 1
bsearch: find nums 2, -1
search end with: left 1, right 0
search: find nums 2, -1
====
[1, 1, 4, ]
bsearch end with: l 2, r 2
bsearch: find nums 2, -1
search end with: left 2, right 1
search: find nums 2, -1
```

那么上面的两个问题就转化成了：

1.  如果可以找到特定数，那么直接返回它就可以
2.  如果没有找到特定数，那么如果需要不大于它的值，则使用 right 对应的数；如果需要不小于它的值，则使用 left 对应的数


#### 返回特定数最左或者最右的下标 {#返回特定数最左或者最右的下标}

假如说一个数组中有大量重复的元素，那么问题可能会要求你返回这个元素靠近较小数字的下标，或者靠近较大数字的下标。

样例的 search 也无法做到这一点，因为它会在搜索到 target 的时候立刻停止。

我通常的做法是，先搜索到那个特定数，然后直接向左或者向右搜索，直到尽头。一般来说效率不是特别高。

一个奇妙的做法是：对于整数题目可以把二分搜索改为 double 类型，然后搜索这个数 +- 0.5。应该可以解决问题。

```cpp
std::pair<int, int> double_search(vector<int>& a, double target) {
    int l = 0, r = a.size() - 1;
    int mid = -1;
    while(l <= r) {
        mid = (l + r) / 2;
        if(a[mid] > target) {
            r = mid - 1;
        } else if(a[mid] < target) {
            l = mid + 1;
        } else {
            return std::make_pair(l, r);
        }
    }
    return std::make_pair(l, r);
}
```

```txt
[1, 1, 2, 2, 2, 4, ]
bsearch: find nums 2, 3
search: find nums 2, 2
double search: find nums 2.0, left 5, right 4
double search: find nums 1.5, left 2, right 1
```


## 堆 {#堆}




### 堆的定义 {#堆的定义}

以小根堆为例：对于堆的每一个节点而言，该节点均比所有自己的子节点小，但是对于其他的子节点不需要关心顺序


### 手撸一个堆 {#手撸一个堆}


#### 二叉堆 {#二叉堆}

堆的储存：一般 vector 就足够了，我们使用线性二叉树来储存这个堆

一个结点的子节点与父节点的下标为：

```cpp
/*
  0
  1 2
  3 4 5 6
  7 8 9 10
  */
int l = i * 2 + 1, r = i * 2 + 2;
int parent = (i - 1) / 2;
```

请记住：如果你要在原来的数组上就地操作的话，你必须手动维护当前堆的大小 heapSize.


#### 堆的更新 O(log(N)) {#堆的更新-o--logn}

堆的每一次更新一定从堆的叶节点开始，向上一直传播到根节点。这个过程一定只会执行一次，不会重复执行。

堆的更新可以分为两种：下沉与上浮

下沉是从根节点开始，从上往下逐个与儿子中更小的那个进行比较，如果不满足堆的条件就进行交换，直到满足条件为止。

```txt
4
8 10
12 14 16 18
# pop
18 <-
8 < 10
12 14 16
---
   8
-> 18 10
   12 < 14 16
---
8
12 10
18 14 16
```

上浮则是相反，从下往上比较，如果不满足堆的条件则交换，直到满足为止。

```txt
4
8 10
12 14 16 18
# push(2)
4
8 10
12 14 16 18
v
2 <-
---
  4
  8 10
  v
->2 14 16 18
  12
---
  4
  v
->2 10
  8 14 16 18
  12
---
2
4 10
8 14 16 18
12
```

其中，建堆与删除操作会使用下沉，而增加操作会使用上浮。

我们来看一个参考实现

```cpp
// 例子都是大根堆
// 从 idx 位置开始进行下沉操作
// 大根堆找儿子结点中大的那个
// 小根堆找儿子结点中小的那个
void sink(vector<int>& a, int i, int heapSize) {
        int l = i * 2 + 1, r = i * 2 + 2, largest = i;
        if (l < heapSize && a[l] > a[largest]) {
            largest = l;
        }
        if (r < heapSize && a[r] > a[largest]) {
            largest = r;
        }
        if (largest != i) {
            swap(a[i], a[largest]);
            sink(a, largest, heapSize);
        }
}

void goup(vector<int>& a, int i) {
    int parent = (i - 1) / 2;
    if(a[parent] < a[i]) {
        swap(a[parent], a[i]);
    }
    if(parent > 0) {
        goup(a, parent);
    }
}
```

我更喜欢迭代的实现方法，不过面试的时候永远是简单的越好。

```cpp
void sink(vector<int>& a, int i, int heapSize) {
        int l = i * 2 + 1, r = i * 2 + 2, largest = i;
        while(l < heapSize || r < heapSize) {
            if (l < heapSize && a[l] > a[largest]) {
                largest = l;
            }
            if (r < heapSize && a[r] > a[largest]) {
                largest = r;
            }
            if (largest != i) {
                swap(a[i], a[largest]);

                i = largest;
                l = i * 2 + 1;
                r = i * 2 + 2;
                largest = i;
            } else {
                break;
            }
        }
}

void goup(vector<int>& a, int i) {
    int parent = (i - 1) / 2;
    while(true) {
        if(a[parent] < a[i]) {
            swap(a[parent], a[i]);
        }
        if(parent > 0) {
            i = parent;
            parent = (i - 1) / 2;
        } else {
            break;
        }
    }
}
```


#### floyd 建堆法O(N) {#floyd-建堆法o--n}

1.  将所有的元素一股脑放进一个 vector 中，组成一个二叉树
2.  从最后一个 **非叶节点** 开始，进行“下沉”操作
3.  逆序处理直到根节点为止。

总共的复杂程度不会超过 O(N)，具体证明忘记了。

这里面最难的一步就是找到最后一个非叶节点的下标。我们不妨认为一共有 n 个数，那么最后一个非叶节点的坐标就是：

```cpp
/*

0
1 2
3 4* 5 6
7 8 9 10
n = 11->4
n = 10->4
*/
void build_heap(vector<int>& a) {
    int n = a.size();
    int start = (n-2)/2; // 实际上从 n / 2 出发也没有任何问题，不过我们还是严谨起见
    for(int i = start; i >= 0; --i) {
        sink(a, i, len);
    }
}
```


#### 堆的操作 {#堆的操作}

堆有三种操作：查看堆顶元素，插入一个元素，移除一个元素

查看堆顶元素 top 只需要返回 heap[0] 即可。

插入元素是在数组的末尾插入元素，然后对该元素进行上浮操作

移除元素是将 top 元素与末尾的元素交换，缩减 heap 的大小，之后对根节点做下沉。


### 使用标准库 {#使用标准库}

C++ 的堆标准库来自 &lt;priority_queue&gt; ，可以用下面的代码调用。

```cpp
#include <iostream>
#include <priority_queue>
using namespace std;
int main() {
    vector<int> nums = {2, 5, 1, 6, 4};
    // 优先级队列通常需要给三个参数
    // 第一个参数是储存数据的类型
    // 第二个参数是储存数据的数据结构，一般使用 vector
    // 第三个是比较函数，一般用 greater<T> 和 less<T> 就可以。其中 less<T> 是大根堆，greater<T>是小根堆
    priority_queue<int, vector<int>, less<int>> big_root_heap(nums.begin(), nums.end());
    priority_queue<int, vector<int>> small_root_heap(nums.begin(), nums.end());
    // 使用 top 函数获得栈顶元素
    cout << small_root_heap.top() << endl;
    // > 1
    // 使用 pop 函数删除元素
    small_root_heap.pop();
    cout << small_root_heap.top() << endl;
    // > 2
    // 使用 push 增加元素
    small_root_heap.push(1);
    cout << small_root_heap.top() << endl;
    // > 1
    return 0;
}
```


### 第 k 个最大的数 {#第-k-个最大的数}


## 滑动窗口 {#滑动窗口}



滑动窗口是一种可以明显降低时间复杂度的方案。滑动窗口可以使得每一次处理的时间和空间都局限在一个窗口内部，这使得一个 O(N) 的问题可以变成每一次 O(k) 处理，一共处理 O(N) 次。滑动窗口问题最困难的部分有两个：一个是每个窗口应该如何处理，二是每次改变窗口的时候应该如何处理。

滑动窗口问题需要首先解决一个问题：应该怎么维护一个窗口？

一般来说一个窗口都是从下标 i 到下标 i + k 的一段区域所设计的元素，我们一般的操作都是要把这个窗口的元素放到某个数据结构当中，然后维护这个窗口。那么我们至少涉及三个操作：向数据结构中增加元素、在数据结构中搜索要删除的元素、删除这个元素。一般来说我们希望时间复杂度不要超过 log(n)，那么我们稍微分析一下这其中的时间开销。

添加数据和删除数据一般不需要大量的时间开销。哪怕使用开销最大的数组作为数据结构，那么我们通常总是可以使用两个指针来表明窗口，而不需要手动维护一个完整的数组（毕竟数组主要是用来储存连续的数据的，如果需要维护特征的话我们肯定需要使用其他的数据结构）

那么就可以发现，绝大部分需要优化的东西都留在了搜索要删除的元素。如果可以把这个工作压到 O(1) ，一般程序就是 O(n) 复杂度了；哪怕不得不是 O(logn) 的时间也是整体 O(nlogn) 的时间。

那么之后分析滑动窗口的问题就非常简单了，我们只需要针对窗口的变化，熟悉我们需要使用的多种不同的数据结构以及维护变化的方法就好了。我们结合题目来进行分析。


### 滑动窗口最大值（堆，单调队列） {#滑动窗口最大值-堆-单调队列}

这是一道非常经典的题目，也是滑动窗口中最朴素的复合题目。

滑动窗口的第一个可用的工具就是堆，因为它总是能维护一个最大值或者最小值。


#### 堆 {#堆}



<!--list-separator-->

-  priority_queue 的特性

    我们先来总结一些奇妙的 priority_queue 特性：

    1.  priority_queue 对于 Pair 有自己默认的排序方法，先后比较 first ，而且优先使用 &lt; 比较符号。所以使用 pair&lt;int, int&gt; 你可以得到一个大根堆：首先是按照第一个元素从大到小排序，然后是按照第二个元素从大到小排序
    2.  priority_queue.emplace 函数可以就地使用构造函数插入一个新的量。
    3.  priority_queue 并不是一个 set，它里面所有的元素是可以重复的！不过这些重复的元素并没有任何提示说明他们什么时候进入的队列

    <!--listend-->

    ```cpp
    priority_queue<int> pq1;
    for(int i = 8;i < 8 * 2; ++i) {
        pq1.push(i / 2);
    }
    while(pq1.size()) {
        printf("%d, ", pq1.top());
        pq1.pop();
    }
    // 7, 7, 6, 6, 5, 5, 4, 4,
    priority_queue<pair<int, int>> pq2;
    for(auto e: {pair<int, int>{5, 3}, pair<int, int>{5, 2}, pair<int, int>{2, 5}, pair<int, int>{3, 4}, pair<int, int>{1, 2}}) {
        pq2.push(e);
    }
    while(pq2.size()) {
        printf("(%d, %d), ", pq2.top().first, pq2.top().second);
        pq2.pop();
    }
    // (5, 3), (5, 2), (3, 4), (2, 5), (1, 2),
    ```

<!--list-separator-->

-  滑动窗口与堆：只要知道什么时候删除



    堆最主要的问题就是说我们没办法只用一个元来维护窗口。因为堆中搜索元素需要 O(N) ，我们根本无法每次都遍历堆然后增减元素。所以我们的思路有两个：

    1.  加快堆搜索元素的效率，比如说把堆中的每个元素和一个搜索结构对应起来（比如说一个 map）
    2.  想办法保证需要删除的元素一定在堆顶（毕竟堆中的其他元素实际上是有一定顺序的，并不需要担心加入数据的时候出现太多问题）

    第一个思路比较朴素，我们可以维护一个 unordered_map 来解决这个问题。记录窗口中所有的元素，并且使用 unordered_map 来维护窗口中元素的个数。然后让 priority_queue 记录 map 中的元素指针就可以做到。但是这也太复杂了，完全没有那个必要。

    第二个思路直接看起来有些困难，我们不妨反过来思考：我们不去考虑找到所有需要删除的元素，只去考虑堆顶的元素什么时候需要被删除即可。也就是说，我们不需要维护堆中的每一个元素，保证他们都在窗口中，我们只要保证我们的堆顶元素在窗口中，那么我们给出的一定是正确答案。解题思路一下子就改成了：

    1.  如何确认堆顶元素在窗口中：记录每个元素的下标，在插入元素的时候就可以根据窗口大小知道这个元素是否在窗口中
    2.  如何维护堆顶元素在窗口中：每次添加新元素的时候检查堆顶元素，如果不在窗口中就删去。重复此步骤，直到满足条件为止

    现在我们就可以利用 priority_queue 的特性，利用一个 pair 来书写这个程序了。

    ```cpp
    class Solution {
    public:
        vector<int> maxSlidingWindow(vector<int>& nums, int k) {
            int n = nums.size();
            priority_queue<pair<int, int>> q;
            for (int i = 0; i < k; ++i) {
                q.emplace(nums[i], i);
            }
            vector<int> ans = {q.top().first};
            for (int i = k; i < n; ++i) {
                q.emplace(nums[i], i);
                // 下面这个步骤是最关键的，删除栈顶元素
                while (q.top().second <= i - k) {
                    q.pop();
                }
                ans.push_back(q.top().first);
            }
            return ans;
        }
    };

    // 作者：力扣官方题解
    // 链接：https://leetcode.cn/problems/sliding-window-maximum/solutions/543426/hua-dong-chuang-kou-zui-da-zhi-by-leetco-ki6m/
    // 来源：力扣（LeetCode）
    // 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
    ```


#### 单调队列 {#单调队列}



单调队列是采用双向队列 deque 的一种处理滑动窗口问题的巧妙方法。它的维护数据结构的逻辑稍微有一点复杂，思路如下：
    我们先准备一个双向队列，它像是传送带一样：我们需要的元素都在它的头部，我们可能需要的数据都在它的中间，我们不需要的数据根本不会进入队列。这有一点像堆，但是我们需要手动维护这个队列。（为什么偏偏要选择一个更难的方法维护？因为有些题目没办法用堆）

对于任何后来的数据而言，它们离开窗口的时间一定晚于之前的数据。如果它们相对于等待的数据而言更加符合题目要求（更优秀）的话，那么排在队尾的一系列数据就都失去了意义：新的数据到来意味着，它们无论在前一个窗口还是后一个窗口都不会被需要，所以只能被淘汰。这样我一定能保证队列中的数据要么是当前窗口最好的，要么是下一个窗口中比较好的，队列中一定不会有没有用的数据。然后需要从队首舍弃一系列过期的数据，这样就可以完成对数据的维护。

有一个不错的比喻就是，这个很像是公司招人。窗口就是一个时间段，头就是这段时间里最优秀的人，中间就是次优的人，其他不够优秀的人完全进不了队列。首先，你为了进入公司，你至少需要比公司里的比较优秀的人要好；要是有新人进来后，发现公司里有很多人还没有新人厉害，那么新人有强，干得时间又久，那么队列中那些中间的人就一定不会出头，他们也就不被需要了。然后我们需要处理的就是太老的人，我们需要把它们舍弃，因为退休时间到了。你看，就这么简单。

对于这道题来说，我们队列中维护的并不是数值，而是下标。单向队列必须要维护下标，因为除此之外我们无法得知窗口什么时候结束。简单的流程如下：

1.  对于每一个新成员，检查是否比队尾的成员优秀。持续删除队尾元素，直到队列中没有元素，或者新数据不够优秀为止。
2.  让新成员加入
3.  持续删除队首的超时数据
4.  输出答案

<!--listend-->

```cpp
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        int n = nums.size();
        deque<int> q;
        for (int i = 0; i < k; ++i) {
            while (!q.empty() && nums[i] >= nums[q.back()]) {
                q.pop_back();
            }
            q.push_back(i);
        }

        vector<int> ans = {nums[q.front()]};
        for (int i = k; i < n; ++i) {
            while (!q.empty() && nums[i] >= nums[q.back()]) {
                q.pop_back();
            }
            q.push_back(i);
            while (q.front() <= i - k) {
                q.pop_front();
            }
            ans.push_back(nums[q.front()]);
        }
        return ans;
    }
};

/*
作者：力扣官方题解
链接：https://leetcode.cn/problems/sliding-window-maximum/solutions/543426/hua-dong-chuang-kou-zui-da-zhi-by-leetco-ki6m/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
*/
```


## 字符串 {#字符串}



字符串考察的内容非常综合，几乎所有的考题都可以从字符串中出出来。其中最基础的是字符串的输入输出，这是 ACM 题目的最基本的一步；其次是数组，因为字符串一般都是用数组储存的；再然后是动归、字符串处理这些更加复杂的算法。在这里我们没办法把所有字符串处理的内容都记录下来，只能就其中比较基础和简单的问题进行一下讨论。


### 字符串基础小知识 {#字符串基础小知识}


#### 字符串的元素顺序 {#字符串的元素顺序}

-   问题：对于字符串 "123456" 而言，哪个数字的下标是 0 ？

    答案：1

    这个问题不能想，必须一下子回答出来。无论是什么编程语言，都是左边的字符下标小，右边的字符下标大。如同写字是从左往右写的。


#### 反转字符串 {#反转字符串}

<https://blog.csdn.net/u014339447/article/details/109232871>

```cpp
string reverse(string s) {
    return string(s.rbegin(), s.rend());
}
```


### C/C++ 的输出输出与字符串 {#c-c-plus-plus-的输出输出与字符串}

众所周知，C/C++ 的输入输出是出了名的费劲，不过我们必须牢记这个过程。


#### 基础输入输出 {#基础输入输出}

16 进制的读写

```cpp
scanf("%X", &x); // %x 也可以
printf("%#x", x); // 这样打印会有 0x 前缀
```

-   %#x：输出带有 0x 前缀的十六进制数。

浮点数的输入输出

scanf 只能读入 float !

```cpp
float f;
scanf("%f", &f); // %e, %E, %g 也可以读入
printf("%0.2f", 0.114514);
printf("%+E", 103801801.0);
printf("%+lf\n", 103801801); // 不要这样！会输出 0.0000 。数据类型一定要正确！
```

-   %-10s：左对齐并占用宽度为 10 的字符串；
-   %+4d：右对齐并占用宽度为 4，强制显示正负号的整数；
-   %5.2f：右对齐并占用宽度为 5，保留两位小数的浮点数；

不知道长度的输入输出

```cpp
int num = 0;
char ans[10][100]; // 10 个长度为 100 的字符数组
while(scanf("%s", ans[num]) != EOF) {
    num++;
}
num = 0;
string s[10];
while(cin >> s[num]) {
    num++;
}
```

C++ split

```cpp
#include <string.h>
#include <stdio.h>
int main() {
    char input[16] = "abc,d";
    char *p;
    /*
      如果找到了分隔符的话，strtok 会在分隔符前加上一个 \0
    */
    p = strtok(input, ","); // 这个函数会破坏原有的字符串，如果需要源字符串则你需要复制一份
    if(p) {
        printf("%s\n", p);
    }
    /*
     之后调用 strtok 需要使用 NULL 作为第一个参数。如果可以分割，则返回字符串指针。如果不行则返回 NULL
     */
    p = strtok(NULL, ",")；
    return 0;
}
```


#### 最长公共子序列：简单的动归 {#最长公共子序列-简单的动归}



一个朴素的 DP 题目


#### <span class="org-todo todo TODO">TODO</span> 字符串匹配：超难动归 KMP {#字符串匹配-超难动归-kmp}

暂时我解释不清楚这个算法，之后再来补上

```cpp
int * buildNext(char *P) {
    size_t m = strlen(P), j = 0;
    int *N = new int[m];
    int t = N[0] = -1;
    while(j < m - 1) {
        (t < 0 || P[j] == P[t]) ? N[++j] = ++t :  t = N[t];
    }
    return N;
}
int match(char *P, char *T) {
    int *next = buildNext(P);
    int n = strlen(T), i = 0;
    int m = strlen(P), j = 0;
    while(j < m && i < n) {
        if(j < 0 || T[i] == P[j]) {
            i++; j++;
        } else {
            j = next[j];
        }
    }
    delete[] next;
    return i - j;
}
```


## 迭代遍历 {#迭代遍历}



您还在为遍历列表是空指针而痛苦吗，您还在为数组下标越界而苦恼吗，您还在为树的遍历不会而头痛吗？来到这里，我们都会一口气解决它们。


### 列表的两个两个走（奇偶链表） {#列表的两个两个走-奇偶链表}


### 数组的二分 {#数组的二分}

为了让大家不再害怕，我们就把二分可能产生的下标情况都列出来。


## 递归 {#递归}

> 一朵名为栈溢出的乌云在程序员的头上飘着。

递归虽然危险很大，但是可以简化一大堆东西。千万不要因为占用栈的空间大而不去使用啊。

-   全局状态的维护
-   递归当前状态的维护
-   递归返回值的讲究。
-   递归与栈的使用


## 二进制 {#二进制}



> 就当是为了我，对它使用指数吧。

1,2,4,8 为核心的指数应该如何使用呢？


### 长除法的代码实现 {#长除法的代码实现}

长除法一般的写法都是竖过来的，因为这样比较方便用手计算：

 2| 11         ^
  ~~----- -- 1  |
 2|  5         |
  +----- -- 1  |
 2|  2         |
  +----- -- 0  |
     1         |
     o---------~~
(11)10 = (1011)2

不过对于计算机来说，我们还是把它横过来写可能会更好一点：

     2    2    2    2
n 11---&gt;5---&gt;2---&gt;1---&gt;0
r    1    1    0    1
  &lt;-----------------o

可以看到，每次进行一次除 2 操作，然后查看除法过程中的余数（在计算机语言中，这个余数需要在除 2之前获得）。持续除 2 直到数字为 0 为止。

很简单对吧，那么我们就来实现最简单的整数转二进制字符串。本题最复杂的步骤实际上是反转字符串。

```cpp
string trans(int n) {
    string s;
    while(n > 0) {
        bit = n % 2;
        n /= 2;
        s.push_back(bit);
    }
    return string(s.rbegin(), s.rend());
}
```


### 二进制 1 的个数（简单） {#二进制-1-的个数-简单}

可以基于长除法解决


### 距离 n 最近的 2 的幂次（简单） {#距离-n-最近的-2-的幂次-简单}


### 基础位运算优化 {#基础位运算优化}



-   对 2 的幂次取模 == 对幂次 - 1 求与
    -   n % 2 == n &amp; 1
    -   n % 8 == n &amp; 7
-   n &amp; n - 1：长除法中的一步除法或求余


### 快速幂运算 {#快速幂运算}

递归

```cpp
class Solution {
public:
    double quickMul(double x, long long N) {
        if (N == 0) {
            return 1.0;
        }
        double y = quickMul(x, N / 2);
        return N % 2 == 0 ? y * y : y * y * x;
    }

    double myPow(double x, int n) {
        long long N = n;
        return N >= 0 ? quickMul(x, N) : 1.0 / quickMul(x, -N);
    }
};
```

迭代

```cpp
class Solution {
public:
    double quickMul(double x, long long N) {
        double ans = 1.0;
        // 贡献的初始值为 x
        double x_contribute = x;
        // 在对 N 进行二进制拆分的同时计算答案
        while (N > 0) {
            if (N % 2 == 1) {
                // 如果 N 二进制表示的最低位为 1，那么需要计入贡献
                ans *= x_contribute;
            }
            // 将贡献不断地平方
            x_contribute *= x_contribute;
            // 舍弃 N 二进制表示的最低位，这样我们每次只要判断最低位即可
            N /= 2;
        }
        return ans;
    }

    double myPow(double x, int n) {
        long long N = n;
        return N >= 0 ? quickMul(x, N) : 1.0 / quickMul(x, -N);
    }
};
```


## 动态规划 {#动态规划}



> 动态规划如天书，虐我千题仍不足。状态转移加初始，整体有向无环图。

这个讲得实在是太好了，建议动态规划不懂的时候就去再看一遍。

<https://leetcode.cn/problems/maximum-subarray/solutions/9058/dong-tai-gui-hua-fen-zhi-fa-python-dai-ma-java-dai/>


### 最大子序列之和 {#最大子序列之和}


### 最长上升子序列 {#最长上升子序列}


### 下降路径最小和 {#下降路径最小和}


## 其他 {#其他}


## 链表 {#链表}


### 链表是否有环 {#链表是否有环}

```cpp
// 判断链表有环
// 有一个非常不错的双指针方法，在 leetcode 的同样题目下有关于链表比较详细的解析
#include <iostream>
#include <vector>
using namespace std;
struct ListNode {
    int val = 0;
    ListNode* next = NULL;
    ListNode(int v = 0) {this->val = v;}
    void print() {
        printf("(%d)[%p]->[%p]->", val, this, next);
    }
};
bool has_loop(ListNode* start) {
    ListNode *first = start, *second = start;
    while(first != NULL && second != NULL) {
        second = second->next;
        if(second == NULL) {
            return false;
        }
        if(second == first) {
            return true;
        }
        second = second->next;
        if(second == NULL) {
            return false;
        }
        if(second == first) {
            return true;
        }
        first = first->next;
    }
    return false;
}
int main() {
    // char str[3];
    // std::cin>>str;

    // 正确的写法：
    vector<ListNode> nodes(3);
    for(int i = 0;i < 3; ++i) {
        nodes[i] = i;
        if(i > 0) {
            nodes[i - 1].next = &nodes[i];
        }
        if(i == 2) {
            nodes[i].next = &nodes[0];
        }
    }

    // 错误的写法:
    // vector<ListNode> nodes;
    // for(int i = 0;i < 3; ++i) {
    //     nodes.push_back(ListNode(i));
    //     if(i > 0) {
    //         nodes[i - 1].next = &nodes[i];
    //     }
    //     if(i == 2) {
    //         nodes[i].next = &nodes[0];
    //     }
    // }
    // 这个代码会因为 vector 的 push_back 而导致内存地址变动，非常危险
    // 如果想把 vector 当数组用，那么最好还是先分配好大小吧。

    ListNode *start = &nodes[0];

    std::cout << has_loop(start) << std::endl;
    return 0;
}
```


## 数组 {#数组}


### 求数组中最大的前两个数以及其对应的下标 {#求数组中最大的前两个数以及其对应的下标}

只需要 4 个变量即可做到
