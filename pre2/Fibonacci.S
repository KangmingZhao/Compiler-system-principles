.arch armv7-a
.arm
.data
@打印n
_cin:
    .asciz "%d"
_bridgea:
    .asciz "a:%d\n"
@打印 b
_bridgeb:
    .asciz "b:%d\n"

_bridge1:
    .asciz "%d\n"

_bridge2:
    .asciz "现在开始循环！\n"

.text
.global main
.type main,%function
main:
    push {fp,lr} @表示将寄存器 fp 和 lr 压入栈中，并更新 sp 指针。

    sub sp,sp,#4 @ int n,准备cin>>n;

    ldr r0,=_cin @  装载格式化字符串 "%d" 到 r0 寄存器，用于 scanf
    mov r1,sp
    bl scanf @调用scanf

    ldr r7,[sp,#0] @加载n到r7当中
    add sp,sp,#4

    @test printf
    @ldr r0,=_bridge1
    @mov r1,r7
    @bl printf

    mov r4,#0 @a=0
    mov r5,#1 @b=1
    mov r6,#1 @i=1
    @初始化完毕 打印进行测试
    
    @打印a
    ldr r0,=_bridgea
    mov r1,r4
    bl printf
    @打印b
    ldr r0,=_bridgeb
    mov r1,r5
    bl printf

    @打印i
    ldr r0,=_bridge1
    mov r1,r6
    bl printf

 @开始计算
    ldr r0,=_bridge2
    bl printf


Loop:
  
    @while 条件 r7为n,r6为i i>=n时跳转
   
    cmp r7,r6
    ble RETURN

    @计算呗
    mov r8,r5 @t=b
    add r5,r4,r5 @b=a+b
    mov r4,r8 @a=t;
    add r6,r6,#1 @i=i+1
    ldr r0,=_bridge1
    mov r1,r5
    bl printf
    b Loop

RETURN:
   pop {fp, lr} @上下文切换
   
   bx lr @return 0

.section .note.GNU-stack,"",%progbits @ do you know what's the use of this :-)
