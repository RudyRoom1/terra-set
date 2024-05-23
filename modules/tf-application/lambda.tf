data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "terra_image_lambda" {
  function_name    = "image-recognition-lambda_terra"
  role             = aws_iam_role.lambda_exec_role.arn
  filename         = "${path.module}/lambda_function_payload.zip"
  runtime          = "python3.10"
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.attach_lambda_policy]
}
