import cv2
path = 'D:\\Dataset\\PCB_dataset\\data\\images\\01_missing_hole_02.jpg'
img = cv2.imread(path)
cv2.imshow('11', img)
cv2.waitKey (0)
cv2.destroyAllWindows()
