import numpy as np
import cv2
from imutils.perspective import four_point_transform
from imutils import contours
from helper import show_images
import imutils


# declare some variables
height = 800
width = 600
green = (0, 255, 0)  # green color
red = (0, 0, 255)  # red color
white = (255, 255, 255)  # white color
questions = 8
answers = 5
correct_ans = [1, 4, 0, 2, 1, 1, 0, 1]

img = cv2.imread("omr_test_02.png")
img = cv2.resize(img, (width, height))
img_copy = img.copy()  # for display purposes
img_copy1 = img.copy()  # for display purposes

gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
blur_img = cv2.GaussianBlur(gray_img, (5, 5), 0)
edge_img = cv2.Canny(blur_img, 10, 70)

# find the contours in the image
contours, _ = cv2.findContours(edge_img, cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)

# draw the contours
cv2.drawContours(img, contours, -1, green, 3)
show_images(["image"], [img])  # helper function in helper.py file


def get_rect_cnts(contours):
    rect_cnts = []
    for cnt in contours:
        # approximate the contour
        peri = cv2.arcLength(cnt, True)
        approx = cv2.approxPolyDP(cnt, 0.02 * peri, True)
        # if the approximated contour is a rectangle ...
        if len(approx) == 4:
            # append it to our list
            rect_cnts.append(approx)
    # sort the contours from biggest to smallest
    rect_cnts = sorted(rect_cnts, key=cv2.contourArea, reverse=True)

    return rect_cnts


rect_cnts = get_rect_cnts(contours)
# warp perspective to get the top-down view of the document
document = four_point_transform(img_copy, rect_cnts[0].reshape(4, 2))
# nếu document quá nhỏ => chứng tỏ ảnh chụp sát nên không có nền
# không cần lấy contour lớn nhất

doc_copy = document.copy()  # for display purposes

cv2.drawContours(img_copy, rect_cnts, -1, green, 3)
# helper function in helper.py file
show_images(["image", "document"], [doc_copy, document])

gray = cv2.cvtColor(doc_copy, cv2.COLOR_BGR2GRAY)
_, thresh = cv2.threshold(gray, 170, 255, cv2.THRESH_BINARY_INV)

show_images(["masked", "thresh"], [doc_copy, thresh])

# find contours in the thresholded image, then initialize
# the list of contours that correspond to questions
cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
cnts = imutils.grab_contours(cnts)
questionCnts = []
# loop over the contours
for c in cnts:
    # compute the bounding box of the contour, then use the
    # bounding box to derive the aspect ratio
    (x, y, w, h) = cv2.boundingRect(c)
    ar = w / float(h)
    # in order to label the contour as a question, region
    # should be sufficiently wide, sufficiently tall, and
    # have an aspect ratio approximately equal to 1
    if w >= 20 and h >= 20 and ar >= 0.9 and ar <= 1.1:
        questionCnts.append(c)

questionCnts = sorted(questionCnts, key=cv2.contourArea)
correct = 0
# each question has 5 possible answers, to loop over the
# question in batches of 5
for q, i in enumerate(np.arange(0, len(questionCnts), answers)):
    # sort the contours for the current question from
    # left to right, then initialize the index of the
    # bubbled answer
    cnts = sorted(questionCnts[i:i + answers], key=cv2.contourArea, reverse=True)
    bubbled = None

    	# loop over the sorted contours
for (j, c) in enumerate(cnts):
		# construct a mask that reveals only the current
		# "bubble" for the question
		mask = np.zeros(thresh.shape, dtype="uint8")
		cv2.drawContours(mask, [c], -1, 255, -1)
		# apply the mask to the thresholded image, then
		# count the number of non-zero pixels in the
		# bubble area
		mask = cv2.bitwise_and(thresh, thresh, mask=mask)
		total = cv2.countNonZero(mask)
		# if the current total has a larger number of total
		# non-zero pixels, then we are examining the currently
		# bubbled-in answer
		if bubbled is None or total > bubbled[0]:
			bubbled = (total, j)
