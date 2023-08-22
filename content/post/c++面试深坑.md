+++
title = "WIP: C++ 知识深坑"
date = 2023-08-15
lastmod = 2023-08-22T21:25:00+08:00
draft = false
katex = true
+++

> 永远不要在面试官前表示自己精通 C++ ，你会死的很惨的


## 前言 {#前言}

如果你在自己的简历上敢写自己的主要编程语言是 C++ 的话，那么恭喜你，你已经走上了最困难的一条路。如果你不是计算机系科班出身，或者对所有的计算机知识至少留有印象的话，那么你可能会被下到汇编、操作系统，上到编程算法被问个体无完肤。不过另一方面，如果你真的可以打好 C++ 的基础，那么计算机的其他部分你肯定可以触类旁通，畅行于计算机的世界而毫无困难。

这个文章希望记录我遇到的和我知道的在面试中，C++ 可能会被面到的问题。其中包括 C++ 的基础，汇编、操统、计算机组成等计算机核心知识，还会包括一些稀奇古怪的题目。希望能够帮到一些同样主要编程语言是 C/C++ ，并且希望能够更加深入了解计算机的人们。


## C 语言 {#c-语言}


### 基本数据类型的大小 {#基本数据类型的大小}

```cpp
#include <stdio.h>
#include <stdbool.h>
int main() {
    printf("sizeof(char)  = %d\n", sizeof(char));
    printf("sizeof(unsigned char)  = %d\n", sizeof(char));
    printf("sizeof(short) = %d\n", sizeof(short));
    printf("sizeof(bool)  = %d\n", sizeof(bool));
    printf("sizeof(int)   = %d\n", sizeof(int));
    printf("sizeof(unsigned int) = %d\n", sizeof(unsigned int));
    printf("sizeof(long)  = %d\n", sizeof(long));
    printf("sizeof(unsigned long)  = %d\n", sizeof(unsigned long));
    printf("sizeof(long long)  = %d\n", sizeof(long long));
    printf("sizeof(unsigned long long)  = %d\n", sizeof(unsigned long long));
    printf("sizeof(void *) = %d\n", sizeof(void *));
    printf("sizeof('hello world') = %d\n", sizeof("hello world"));
    printf("sizeof(float)   = %d\n", sizeof(float));
    printf("sizeof(double)   = %d\n", sizeof(double));
    return 0;
    /*
        sizeof(char)  = 1
        sizeof(unsigned char)  = 1
        sizeof(short) = 2
        sizeof(bool)  = 1
        sizeof(int)   = 4
        sizeof(unsigned int) = 4
        sizeof(long)  = 8 // 64 位 unix 为 8B, x86-64 为 4B
        sizeof(unsigned long)  = 8 // 64 位 unix 为 8B, x86-64 为 4B
        sizeof(long long)  = 8
        sizeof(unsigned long long)  = 8
        sizeof(void *) = 8
        sizeof('hello world') = 12
        sizeof(float)   = 4
        sizeof(double)   = 8
    */
}
```

上面的内容都是最为基础的知识，或者说它们大多没有什么需要注意的地方，基本上背诵记忆即可。

不过仔细想想，有一些多少可以讲解一点的东西，我们来看一下：


#### 基础的大小单位 {#基础的大小单位}

-   比特 bit
    0，1 两个值，是数据处理和储存的最小单位，代表两个状态。一般在电脑中利用电平表示。
-   字节（Byte）
    一个字节 8 bit。（别问！字节的大小是定义的，现在就是 8 位，就当没有什么理由就可以了。）

    最经典的一个字节长的东西就是 char，对应一个 ascii 码。
-   字 WORD
    定义为两个字节，8B, 16 bits

    经典的一个字大小的东西是 short
-   双字 DWORD

    如同字面意思，两个字的长度，32 bits

    int 的大小，实在没有什么好说的了。

-   四字 QWORD

    字面意思 4 个字长度，64 bits

    典型的 64 位大小为 c++11 后的 long long 类型长度以及 64 位机的指针大小（毕竟地址线宽就是 64 位，指针当然也得是 64 位）

-   字长

    字长和字节虽然有同样的一个字，不过这两个概念没有半毛钱关系！

    你可以认为字长是计算机的传输线宽，计算机的各种组成单元在一次存取、加工、传送时可以使用的数据长度就是字长。

    我们常说的 32位机、64位机说的就是字长

    我们以 64 位机为例子，字长为 8B


#### 指针的大小 {#指针的大小}

指针的大小永远和计算机的字长一样大，所以如果是 32 位的电脑就是 4 字节，64 位就是 8 字节


#### 字符串的大小 {#字符串的大小}

`"hello world"` 一共 11 个字母，但是长度为 12B ，因为字符串的末尾会被添加 \\0 作为终止符号。


### struct 的内存结构 {#struct-的内存结构}

```cpp

```


## C++ 语言 {#c-plus-plus-语言}


### 类的成员函数 {#类的成员函数}

<https://blog.csdn.net/fuzhongmin05/article/details/59112081>

请回答下面的问题：

```cpp
#include <iostream>
using namespace std;

class D {
public:
    char i;
    void func1() {
        cout << "func1" << endl;
    }
    virtual void func2() {
        cout << "func2" << endl;
    }
};

int main() {
    D* a = new D(), *b = NULL;
    a->func1();                 // func1
    a->func2();                 // func2
    cout << sizeof(a) << endl;  // 8 (64 bit)
    cout << sizeof(*a) << endl; // 16 (虚指针 + 对齐后的 char)
    delete a;
    b->func1();                 // func1
    b->func2();                 // segmentfault
    return 0;
}
```


### 多态 {#多态}

<https://zhuanlan.zhihu.com/p/529726280>

请回答下面的问题：

```cpp
#include <iostream>
using namespace std;

class A {
    virtual void func() {
        cout << "funcA" << endl;
    }
    void nfunc() {
        cout << "nfuncA" << endl;
    }
};

class B: class A {
    void func() {
        cout << "funcB" << endl;
    }
    void nfunc() {
        cout << "nfuncB" << endl;
    }
}

void print_func1(A* p) {
    p->func();
    p->nfunc();
}

void print_func2(A& p) {
    p.func();
    p.nfunc();
}

int main() {
    B* b = new B();
    A* a = b;
    a->func();          // funcB
    a->nfunc();         // nfuncA
    b->func();          // funcB
    b->nfunc();         // nfuncB
    (*a).func();        // funcB
    (*a).nfunc();       // nfuncA
    (*b).func();        // funcB
    (*b).nfunc();       // nfuncB
    print_func1(a);     // funcB, nfuncA
    print_func1(b);     // funcB, nfuncA
    print_func2(*a);    // funcB, nfuncA
    print_func2(*b);    // funcB, nfuncA
    delete b;
    return 0;
}
```


## 计算机网络 {#计算机网络}


## 操作系统 {#操作系统}




### 物理内存和虚拟内存 {#物理内存和虚拟内存}

<https://zhuanlan.zhihu.com/p/529726280>
