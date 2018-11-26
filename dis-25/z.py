def z(f):
    return (lambda x: f(lambda y: x(x)(y)))(lambda x: f(lambda y: x(x)(y)))


def pre_fact(f):
    return lambda n: 1 if n == 0 else n * f(n - 1)


def fact():
    return z(pre_fact)


print(fact()(3))
