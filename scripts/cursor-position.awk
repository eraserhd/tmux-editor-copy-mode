{
    lines[line_count++] = $0;
}
END{
    printf("%s=%d\n", lineVar, (line_count - (height - y) + 1));
}
