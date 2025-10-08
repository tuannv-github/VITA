from .dataset_config import *

NaturalCap = [LLaVADataset]
GO2RobotDatasets = [GO2RobotDataset]

DataConfig = {
    "llava-instruct-150k": NaturalCap,
    "go2_robot": GO2RobotDatasets
}

NoPatchSets = ["khair", "jester"]
