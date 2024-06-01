---
title: 树莓派5-LED-Platform驱动
index_img: /img/index/rpi.png
banner_img: /img/banner/code.jpg
date: 2024-06-01 13:31:49
updated: 2024-06-01 13:31:49
tags:
- platform
- gpio
- dts
categories:
- 树莓派驱动
---
## 1 选择 GPIO 引脚

在树莓派的扩展口中以 [GPIO17](https://pinout.xyz/pinout/pin11_gpio17/) 为例，点亮 LED 灯。

![](686d5a50e65e8be9d3068fa4c00c26cf_MD5.jpeg)

GPIO17 介绍：

![](a98d4024377461eb5bd55f6bcb4e7248_MD5.jpeg)

## 2 配置设备树 dts

树莓派5 的设备树文件是 `arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b.dts` :

```dts
#include "arm/broadcom/bcm2712-rpi-5-b.dts"
```

因为包含了 arm 下的 dts，所以修改 `arch/arm/boot/dts/broadcom/bcm2712-rpi-5-b.dts`，添加 jw_led 节点：

```dts
/ {
	...
	led: leds {
		...
	};
	//在此处添加 jw_led 节点
	jw_led: jw_gpio17 {
	};
	...
};
...
#include "rp1.dtsi"
...
gpio: &rp1_gpio {
	status = "okay";
};
//在此处引用修改 jw_led 节点
&jw_led {
	compatible = "jw,jwled369";
	led-gpios = <&gpio 17 GPIO_ACTIVE_HIGH>;
}
```

关于 rp1 芯片阅读官方的数据手册。

## 3 编写 Platform 驱动

代码如下：

```c
#include <linux/of.h>
#include <linux/gpio/consumer.h>
#include <linux/platform_device.h>
#include <linux/module.h>

#define DRIVER_NAME "jw_led"

struct jw_led {
    struct gpio_desc *gpio;
};

static int jw_led_probe(struct platform_device *pdev)
{
    struct jw_led *led;

    led = devm_kzalloc(&pdev->dev, sizeof(struct jw_led), GFP_KERNEL);
    if (!led)
        return -ENOMEM;

    platform_set_drvdata(pdev, led);

    led->gpio = devm_gpiod_get_index(&pdev->dev, "led", 0, GPIOD_OUT_LOW);
    if (IS_ERR(led->gpio)) {
        dev_err(&pdev->dev, "Failed to get jw_led/led-gpios property: %ld\n",
                PTR_ERR(led->gpio));
        return PTR_ERR(led->gpio);
    }

    /* 在这里可以添加其他代码来控制 GPIO17 */
    // gpiod_set_value(led->gpio, 1);

    return 0;
}

static const struct of_device_id jw_led_of_match[] = {
    { .compatible = "jw,jwled369", },
    { /* end of list */ },
};
MODULE_DEVICE_TABLE(of, jw_led_of_match);

static struct platform_driver jw_led_driver = {
    .probe = jw_led_probe,
    .driver = {
        .name = DRIVER_NAME,
        .of_match_table = jw_led_of_match,
    },
};
module_platform_driver(jw_led_driver);

MODULE_AUTHOR("jw.lee");
MODULE_DESCRIPTION("LED driver");
MODULE_LICENSE("GPL v2");
```

最后，编译成模块在树莓派上 insmod 即可。