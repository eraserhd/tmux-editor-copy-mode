BEGIN{
    screen_line_count = 0;
}
{
    while (length() > width) {
        file_line[screen_line_count] = NR;
        screen_lines[screen_line_count] = substr($0, 0, width);
        $0 = substr($0, width);
        screen_line_count++;
    }
    file_line[screen_line_count] = NR;
    screen_lines[screen_line_count] = $0;
    screen_line_count++;
}
END{
    screen_line_index = screen_line_count - height + y;
    printf "%s=%d\n", lineVar, file_line[screen_line_index];
}
