from scan import scan
import cv2

image = cv2.imread("IMG_0122.JPG")
scanned = scan(image)  # scan hinh

# tim phan cau tra loi
available_choices = 5
