
# 终端颜色代码和文本效果

此文档介绍了一些常见的终端颜色代码和文本效果，通过使用 ANSI 转义码可以实现丰富的文本输出效果。

## 前景色（文本颜色）

- **黑色**：
  ```bash
  echo -e "\033[0;30mThis is black text\033[0m"
  ```

- **红色**：
  ```bash
  echo -e "\033[0;31mThis is red text\033[0m"
  ```

- **绿色**：
  ```bash
  echo -e "\033[0;32mThis is green text\033[0m"
  ```

- **黄色**：
  ```bash
  echo -e "\033[0;33mThis is yellow text\033[0m"
  ```

- **蓝色**：
  ```bash
  echo -e "\033[0;34mThis is blue text\033[0m"
  ```

- **紫色（洋红色）**：
  ```bash
  echo -e "\033[0;35mThis is magenta text\033[0m"
  ```

- **青色**：
  ```bash
  echo -e "\033[0;36mThis is cyan text\033[0m"
  ```

- **白色**：
  ```bash
  echo -e "\033[0;37mThis is white text\033[0m"
  ```

- **深灰色**：
  ```bash
  echo -e "\033[1;30mThis is dark gray text\033[0m"
  ```

- **浅红色**：
  ```bash
  echo -e "\033[1;31mThis is light red text\033[0m"
  ```

- **浅绿色**：
  ```bash
  echo -e "\033[1;32mThis is light green text\033[0m"
  ```

- **浅黄色**：
  ```bash
  echo -e "\033[1;33mThis is light yellow text\033[0m"
  ```

- **浅蓝色**：
  ```bash
  echo -e "\033[1;34mThis is light blue text\033[0m"
  ```

- **浅紫色**：
  ```bash
  echo -e "\033[1;35mThis is light magenta text\033[0m"
  ```

- **浅青色**：
  ```bash
  echo -e "\033[1;36mThis is light cyan text\033[0m"
  ```

- **浅白色**：
  ```bash
  echo -e "\033[1;37mThis is light white text\033[0m"
  ```

## 背景色

- **黑色**：
  ```bash
  echo -e "\033[40mThis is text with black background\033[0m"
  ```

- **红色**：
  ```bash
  echo -e "\033[41mThis is text with red background\033[0m"
  ```

- **绿色**：
  ```bash
  echo -e "\033[42mThis is text with green background\033[0m"
  ```

- **黄色**：
  ```bash
  echo -e "\033[43mThis is text with yellow background\033[0m"
  ```

- **蓝色**：
  ```bash
  echo -e "\033[44mThis is text with blue background\033[0m"
  ```

- **紫色（洋红色）**：
  ```bash
  echo -e "\033[45mThis is text with magenta background\033[0m"
  ```

- **青色**：
  ```bash
  echo -e "\033[46mThis is text with cyan background\033[0m"
  ```

- **白色**：
  ```bash
  echo -e "\033[47mThis is text with white background\033[0m"
  ```

## 文本效果

- **粗体**：
  ```bash
  echo -e "\033[1mThis is bold text\033[0m"
  ```

- **斜体**（并不是所有终端都支持）：
  ```bash
  echo -e "\033[3mThis is italic text\033[0m"
  ```

- **下划线**：
  ```bash
  echo -e "\033[4mThis is underlined text\033[0m"
  ```

- **反转颜色**：
  ```bash
  echo -e "\033[7mThis is reversed text\033[0m"
  ```

## 结尾

要重置文本格式到默认状态，使用 `\033[0m`。可以根据需要组合这些代码来实现各种颜色和文本效果。
