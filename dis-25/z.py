def self_pre_fact(f):
    return lambda n: 1 if n == 0 else n * f(f)(n - 1)


def self_fact(n):
    return self_pre_fact(self_pre_fact)(n)


def z(f):
    return (lambda x: f(lambda y: x(x)(y)))(lambda x: f(lambda y: x(x)(y)))


def pre_fact(f):
    return lambda n: 1 if n == 0 else n * f(n - 1)


def fact(n):
    return z(pre_fact)(n)


def pre_collatz(f):
    return lambda n: 0 if n == 1 else 1 + f(n // 2) if n % 2 == 0 else 1 + f(3 * n + 1)


def collatz(n):
    return z(pre_collatz)(n)


print(collatz(12))
