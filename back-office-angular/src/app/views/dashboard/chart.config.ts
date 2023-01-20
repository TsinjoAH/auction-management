import {getStyle, hexToRgba} from "@coreui/utils/src";

export const brandSuccess = getStyle('--cui-success') ?? '#4dbd74';
export const brandInfo = getStyle('--cui-info') ?? '#20a8d8';
export const brandInfoBg = hexToRgba(getStyle('--cui-info'), 10) ?? '#20a8d8';
export const brandDanger = getStyle('--cui-danger') || '#f86c6b';

const plugins = {
  legend: {
    display: false
  },
  tooltip: {
    callbacks: {
      labelColor: function(context: any) {
        return {
          backgroundColor: context.dataset.borderColor
        };
      }
    }
  }
};

export const getOptions = (yMax: number) => {
  return {
    maintainAspectRatio: false,
    ...plugins,
    scales: {
      x: {
        grid: {
          drawOnChartArea: true
        }
      },
      y: {
        beginAtZero: true,
        max: yMax,
        ticks: {
          maxTicksLimit: 5,
          stepSize: Math.ceil(yMax / 5)
        }
      }
    },
    elements: {
      line: {
        tension: 0.4
      },
      point: {
        radius: 0,
        hitRadius: 10,
        hoverRadius: 4,
        hoverBorderWidth: 3
      }
    }
  };
}
