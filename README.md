# RGB-D Camera extrinsic parameter automatically calibration
## Purpose
Automatically detect the ground plane, build the world coordinate  and estimate the extrinsic parameter of the moving camera.


## Rquirement
- MATLAB R2016 or newer
- have mj2 decoder (support mj2 video)

## Run
- Download [demo videos](https://pan.baidu.com/s/1pLeAog7), and move "color.avi" and "depth.mj2" to work directory.
- cd work directory
- run "main"

## Result

![](./result/result.gif)

> Our method can automatically detect the ground plane. Based the detected plane, we build a world coordinate and estimate the extrinsic parameters of the RGB-D camera.

## Cite
If you use this method or inspired by this method, please cite the [paper](./result/paper.pdf):

### English version
- Sun S J, Song H S, Zhang C Y, Zhang W T, Wang X	. Automatic extrinsic calibration for RGB-D camera based on ground plane detection in point cloud[J]. Journal of Image and Graphics, 2018, 23(6): 866-873.

### Chinese version
- [孙士杰, 宋焕生, 张朝阳, 张文涛, 王璇. 点云下地平面检测的RGB-D相机外参自动标定[J]. 中国图象图形学报, 2018, 23(6): 866-873.]\[DOI: 10.11834/jig.170490] 
