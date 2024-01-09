
基于自适应多成对PEE的RDH方法 
=======


论文名： "[Reversible data hiding based on multiple adaptive two-dimensional prediction-error histograms modification](https://ieeexplore.ieee.org/document/9605567)" (2022年发表于TCSVT).


## 方法简介

提出了一个自适应2D映射的生成方法，为基于高维映射的预测误差扩展方法提供了一个优化方案

<p align="center"> <img src="./results/work.jpg" width="70%">    </p>
<p align="center"> 图1: 自适应多个2D映射生成框架. </p>


## 如何运行


### 基础方法 
论文的主要方法实现
```
## cd ./Basic

run main.m 
```

### 扩展方法
论文最后讨论的三种扩展方法
```
## cd ./V1_fig16(a)

run main.m
```
```
## cd ./V1_fig16(b)

run main.m
```
```
## cd ./V1_fig16(c)

run main.m
```

## 实验结果

<p align="center"> <img src="./results/R0.jpg" width="60%">    </p>
<p align="center"> 图2: 生成的自适应2D映射. </p>

<p align="center"> <img src="./results/R1.jpg" width="60%">    </p>
<p align="center"> 图3: Lena和Baboon图像的PSNR结果. </p>

<p align="center"> <img src="./results/R2.jpg" width="60%">    </p>
<p align="center"> 图4: 给定容量下的PSNR. </p>

<p align="center"> <img src="./results/R3.jpg" width="60%">    </p>
<p align="center"> 图5: 对比扩展方法. </p>


## 实验环境
Matlab 2016b <br>


## 致谢
这项工作由中国国家自然科学基金（NSFC）支持，基金号： Nos. 61872128, 92067104



## 引用格式
如果这项工作对您的研究有帮助, 请按如下格式引用：
```
@ARTICLE{9605567,
  author={Zhang, Cheng and Ou, Bo},
  journal={IEEE Transactions on Circuits and Systems for Video Technology}, 
  title={Reversible Data Hiding Based on Multiple Adaptive Two-Dimensional Prediction-Error Histograms Modification}, 
  year={2022},
  volume={32},
  number={7},
  pages={4174-4187},
  doi={10.1109/TCSVT.2021.3125711}}
```

## 版权声明
本项目已开源 (详见 ``` MIT LICENSE ``` ).

