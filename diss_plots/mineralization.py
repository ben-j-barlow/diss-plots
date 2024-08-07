import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 10, 500)
m = np.exp(-((x-5)**2)/2)
r = np.sin(x) * 0.1
z = m + r
t = 0.5
i = np.where(z > t, z - t, 0)

fig, axs = plt.subplots(4, 1, figsize=(8, 10), sharex=True)

# Subplot (a)
axs[0].plot(x, m, 'b')
axs[0].fill_between(x, 0, m, color='blue', alpha=0.1)
axs[0].annotate(r'$\sigma$', xy=(5, 0.5), xytext=(5, 0.8), arrowprops=dict(facecolor='black', arrowstyle='<->'))
axs[0].text(10.5, 0.5, 'mineralization', verticalalignment='center')
axs[0].set_ylabel('(a) $m(x)$')

# Subplot (b)
axs[1].plot(x, r, 'b')
axs[1].fill_between(x, 0, r, color='blue', alpha=0.1)
axs[1].text(10.5, 0.05, 'geological\nbackground\nvariation', verticalalignment='center')
axs[1].set_ylabel('(b) $r(x)$')

# Subplot (c)
axs[2].plot(x, z, 'b')
axs[2].hlines(t, 0, 10, colors='gray', linestyles='dashed')
axs[2].vlines([3, 7], 0, [z[150], z[350]], colors='gray', linestyles='dotted')
axs[2].fill_between(x, t, z, where=(z > t), color='blue', alpha=0.1)
axs[2].text(10.5, 0.5, 'Measureable\nvariation', verticalalignment='center')
axs[2].annotate(r'$o_1 = z(x = a_1)$', xy=(3, z[150]), xytext=(1, 0.8), arrowprops=dict(facecolor='black', arrowstyle='->'))
axs[2].annotate(r'$o_2 = z(x = a_2)$', xy=(7, z[350]), xytext=(8, 0.8), arrowprops=dict(facecolor='black', arrowstyle='->'))
axs[2].text(5, 0.55, 'threshold $t$', horizontalalignment='center')
axs[2].set_ylabel('(c) $z(x)$')

# Subplot (d)
axs[3].plot(x, i, 'b')
axs[3].fill_between(x, 0, i, color='blue', alpha=0.1)
axs[3].text(10.5, 0.25, 'economic\nparameter', verticalalignment='center')
axs[3].annotate(r'$v = \int i(x)dx$', xy=(5, 0.25), xytext=(7, 0.4), arrowprops=dict(facecolor='black', arrowstyle='->'))
axs[3].set_ylabel('(d) $i(x)$')
axs[3].set_xlabel('$x$')

for ax in axs:
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 1)

plt.tight_layout()
plt.savefig('mineralization_plot.png')
plt.show()
