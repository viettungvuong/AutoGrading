from grade import grade_paper
from flask import Flask, jsonify, request, jsonify, json
import os

# cv2.imshow("A", image)
# cv2.waitKey()

# tạo endpoint để chạy script
UPLOAD_FOLDER = "./uploads"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg"}
app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


@app.route("/grade", methods=["POST"])
def grade_image():
    if request.method == "POST":
        if "file" not in request.files:
            return jsonify({"error": "No file part"})

        file = request.files["file"]

        if file.filename == "":
            return jsonify({"error": "No selected file"})

        if file:
            filename = file.filename
            current_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            file.save(current_path)
            available_choices = int(request.form.get("available_choices", 5))

            right_answers = json.loads(
                request.form.get("right_answers", "{}")
            )  # convert json to dictionary
            right_answers = {int(key): value for key, value in right_answers.items()}

            correct = grade_paper(current_path, available_choices, right_answers)
            print(correct)

            # Return the grading result
            response_data = {
                "correct_answers": correct,
            }

            # hình result sẽ có sau

            return jsonify(response_data)
    return jsonify({"error": "Invalid request method"})


if __name__ == "__main__":
    app.run(port=8000)
