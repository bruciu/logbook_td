
from lab2 import *

impostato, v0, v1 = load('presa5')


x = v0
y = v1
dx = np.array(x)*0+1
dy = np.array(x)*0+1

g = Grafico()


g.data.xData = x[1:]
g.data.yData = y[1:]
g.data.dxData = dx[1:]
g.data.dyData = dy[1:]

init = [1, 0]
def f(x, a, b) :
    return x / a + b

g.fitParams.model = f
g.fitParams.params = init
g.fitParams.model = f
g.fitParams.params = np.array(init)
g.plotParams.plot_errors = False
g.plotParams.plot_model = True
g.plotParams.title = 'partitore'
g.plotParams.nome_asse_y = 'letture ADC'
g.plotParams.unita_asse_y = '[V]'
g.plotParams.nome_asse_x = 'tempo'
g.plotParams.unita_asse_x = '[V]'
g.fitParams.absolute_sigma = False
g.plotParams.plot_residui = True
g.plotParams.residui_normalizzati = False
g.fit()
g.plot()
