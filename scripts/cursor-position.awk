BEGIN{
    screen_line_count = 0;
}
{
    gsub(/\x1B\[[0-9;]*m/, "");
    start_column = 1;
    while (length() > width) {
        file_line[screen_line_count] = NR;
        file_column[screen_line_count] = start_column;
        screen_lines[screen_line_count] = substr($0, 0, width);
        $0 = substr($0, width);
        screen_line_count++;
        start_column += width;
    }
    file_line[screen_line_count] = NR;
    file_column[screen_line_count] = start_column;
    screen_lines[screen_line_count] = $0;
    screen_line_count++;
}
END{
    screen_line_index = screen_line_count - height + y;
    printf "%s=%d\n", lineVar, file_line[screen_line_index];
    printf "%s=%d\n", columnVar, file_column[screen_line_index] + x;
}
