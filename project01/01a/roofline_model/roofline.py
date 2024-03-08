import matplotlib.pyplot as plt
import numpy as np


def roofline(ax, peak_performance, memory_bandwidth, operational_intensity, label=None):
    ax.plot(operational_intensity, np.minimum(peak_performance,
            memory_bandwidth * operational_intensity), label=label)
    ax.set_xlabel('Operational Intensity (GFLOP/Byte)')
    ax.set_ylabel('Performance (GFLOP/cycle)')
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.set_title(f'Roofline Model')
    ax.grid(True)
    ax.legend(loc='best')


def main():

    operational_intensity = np.logspace(-2, 3, 100)
    fig, ax = plt.subplots()

    roofline(ax, 41.6, 20, operational_intensity, "EPYC_7H12")

    roofline(ax, 39.2, 25, operational_intensity, "EPYC_7763")

    plt.show()
    # plt.savefig(f'roofline.png')


if __name__ == '__main__':
    main()
