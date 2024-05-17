# Start FROM Nvidia PyTorch image https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
#FROM nvcr.io/nvidia/pytorch:21.05-py3


#WORKDIR /home/workdir
#FROM python:3.9.0
FROM continuumio/anaconda3

COPY detect.py .
#COPY best.pt .

RUN apt-get update && apt-get install -y \
    zip \
    htop \
    screen \
    libgl1-mesa-glx

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml || true
#RUN echo "source activate $(head -1 environment.yml | cut -d' ' -f2)" > ~/.bashrc
#ENV PATH /opt/conda/envs/$(head -1 environment.yml | cut -d' ' -f2)/bin:$PATH
#CMD ["/bin/bash"]
# Install linux packages
RUN apt update && apt install -y zip htop screen libgl1-mesa-glx

# Install python dependencies
COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip uninstall -y nvidia-tensorboard nvidia-tensorboard-plugin-dlprof
#RUN pip install --no-cache -r requirements.txt coremltools onnx gsutil notebook
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ -r requirements.txt

#ENV PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple/
RUN pip install --no-cache -U scipy
RUN pip install --no-cache -U torch torchvision numpy
RUN pip install torch==1.10.1+cu102 torchvision==0.11.2+cu102 torchaudio==0.10.1 -f https://download.pytorch.org/whl/cu102/torch_stable.html


ADD . /usr/src/app/uniform/yolo

CMD ["python", "detect.py"]
WORKDIR /usr/src/app/uniform/yolo

# Create working directory
#RUN mkdir -p /usr/src/app
#WORKDIR /usr/src/app

# Copy contents
#COPY . /usr/src/app

# Set environment variables
#ENV HOME=/usr/src/app


# Usage Examples -------------------------------------------------------------------------------------------------------

# Build and Push
# t=ultralytics/yolov5:latest && sudo docker build -t $t . && sudo docker push $t

# Pull and Run
# t=ultralytics/yolov5:latest && sudo docker pull $t && sudo docker run -it --ipc=host --gpus all $t

# Pull and Run with local directory access
# t=ultralytics/yolov5:latest && sudo docker pull $t && sudo docker run -it --ipc=host --gpus all -v "$(pwd)"/datasets:/usr/src/datasets $t

# Kill all
# sudo docker kill $(sudo docker ps -q)

# Kill all image-based
# sudo docker kill $(sudo docker ps -qa --filter ancestor=ultralytics/yolov5:latest)

# Bash into running container
# sudo docker exec -it 5a9b5863d93d bash

# Bash into stopped container
# id=$(sudo docker ps -qa) && sudo docker start $id && sudo docker exec -it $id bash

# Clean up
# docker system prune -a --volumes
