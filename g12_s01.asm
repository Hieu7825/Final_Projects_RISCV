.eqv MONITOR_SCREEN        0x10010000
.eqv KEYBOARD_STATUS       0xFFFF0000
.eqv KEYBOARD_DATA         0xFFFF0004
.eqv YELLOW                0x00FFFF00
.eqv BLACK                 0x00000000
.eqv SCREEN_WIDTH          512
.eqv SCREEN_HEIGHT         512

.data
dir: .word 0               # Huong: 0=dung, 1=up, 2=down, 3=left, 4=right
ball_x: .word 256          # Toa do x cua qua bong
ball_y: .word 256          # Toa do y cua qua bong
ball_radius: .word 17      # Ban kinh qua bong  
speed: .word 2             # Toc do di chuyen
delay_time: .word 50       # Thoi gian delay
border_thickness: .word 3  # Do day vien

.text
main:
    # Khoi tao vi tri ban dau o tam man hinh
    li t0, 256
    la t1, ball_x
    sw t0, 0(t1)
    la t1, ball_y
    sw t0, 0(t1)
    
draw_initial_ball:
    # Ve qua bong ban dau
    li a0, YELLOW
    jal draw_thick_circle
    
main_loop:
    jal handle_key_input
    
    # Kiem tra co di chuyen khong
    la t0, dir
    lw t1, 0(t0)
    beqz t1, main_loop
    
    # Xoa qua bong cu
    li a0, BLACK
    jal draw_thick_circle
    
    # Di chuyen theo huong
    jal move_ball
    
    # Ve qua bong moi
    li a0, YELLOW
    jal draw_thick_circle
    
    # Delay
    la t0, delay_time
    lw a0, 0(t0)
    li a7, 32
    ecall
    
    j main_loop

move_ball:
    # Lay toc do hien tai
    la t0, speed
    lw t5, 0(t0)
    
    la t0, dir
    lw t1, 0(t0)
    
    li t2, 1
    beq t1, t2, move_up
    li t2, 2
    beq t1, t2, move_down
    li t2, 3
    beq t1, t2, move_left
    li t2, 4
    beq t1, t2, move_right
    jr ra

move_up:
    la t0, ball_y
    lw t1, 0(t0)
    sub t1, t1, t5
    
    la t2, ball_radius
    lw t2, 0(t2)
    blt t1, t2, bounce_down
    
    sw t1, 0(t0)
    jr ra

move_down:
    la t0, ball_y
    lw t1, 0(t0)
    add t1, t1, t5
    
    la t2, ball_radius
    lw t2, 0(t2)
    li t3, SCREEN_HEIGHT
    sub t3, t3, t2
    bgt t1, t3, bounce_up
    
    sw t1, 0(t0)
    jr ra

move_left:
    la t0, ball_x
    lw t1, 0(t0)
    sub t1, t1, t5
    
    la t2, ball_radius
    lw t2, 0(t2)
    blt t1, t2, bounce_right
    
    sw t1, 0(t0)
    jr ra

move_right:
    la t0, ball_x
    lw t1, 0(t0)
    add t1, t1, t5
    
    la t2, ball_radius
    lw t2, 0(t2)
    li t3, SCREEN_WIDTH
    sub t3, t3, t2
    bgt t1, t3, bounce_left
    
    sw t1, 0(t0)
    jr ra

bounce_up:
    li t1, 1
    la t0, dir
    sw t1, 0(t0)
    jr ra

bounce_down:
    li t1, 2
    la t0, dir
    sw t1, 0(t0)
    jr ra

bounce_left:
    li t1, 3
    la t0, dir
    sw t1, 0(t0)
    jr ra

bounce_right:
    li t1, 4
    la t0, dir
    sw t1, 0(t0)
    jr ra

# Ve duong tron voi vien day bang thuat toan Bresenham cai tien
draw_thick_circle:
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw a0, 36(sp)
    
    # Luu mau
    mv s0, a0
    
    # Lay toa do tam, ban kinh va do day
    la t0, ball_x
    lw s1, 0(t0)        # s1 = center_x
    la t0, ball_y
    lw s2, 0(t0)        # s2 = center_y
    la t0, ball_radius
    lw s3, 0(t0)        # s3 = radius
    la t0, border_thickness
    lw s7, 0(t0)        # s7 = thickness
    
    # Ve nhieu duong tron long nhau de tao vien day
    li s6, 0            # thickness_counter = 0 (dem do day)
    
thickness_loop:
    bge s6, s7, circle_done
    
    # Tinh ban kinh hien tai = radius - thickness_counter
    sub s4, s3, s6      # current_radius = radius - thickness_counter
    blez s4, next_thickness
    
    # Ve duong tron voi ban kinh s4 bang thuat toan Bresenham
    li t0, 0            # x = 0
    mv t1, s4           # y = radius
    li t2, 1
    sub t2, t2, s4      # d = 1 - radius
    
bresenham_loop:
    blt t1, t0, next_thickness  # if y < x, ket thuc
    
    # Ve 8 diem doi xung
    # (x, y)
    add a0, s1, t0      # center_x + x
    add a1, s2, t1      # center_y + y
    jal draw_pixel
    
    # (-x, y)
    sub a0, s1, t0      # center_x - x
    add a1, s2, t1      # center_y + y
    jal draw_pixel
    
    # (x, -y)
    add a0, s1, t0      # center_x + x
    sub a1, s2, t1      # center_y - y
    jal draw_pixel
    
    # (-x, -y)
    sub a0, s1, t0      # center_x - x
    sub a1, s2, t1      # center_y - y
    jal draw_pixel
    
    # (y, x)
    add a0, s1, t1      # center_x + y
    add a1, s2, t0      # center_y + x
    jal draw_pixel
    
    # (-y, x)
    sub a0, s1, t1      # center_x - y
    add a1, s2, t0      # center_y + x
    jal draw_pixel
    
    # (y, -x)
    add a0, s1, t1      # center_x + y
    sub a1, s2, t0      # center_y - x
    jal draw_pixel
    
    # (-y, -x)
    sub a0, s1, t1      # center_x - y
    sub a1, s2, t0      # center_y - x
    jal draw_pixel
    
    # Cap nhat Bresenham
    addi t0, t0, 1      # x++
    
    blt t2, zero, d_negative
    # d >= 0
    addi t1, t1, -1     # y--
    slli t3, t0, 1      # 2*x
    slli t4, t1, 1      # 2*y
    sub t3, t3, t4      # 2*x - 2*y
    addi t3, t3, 1      # 2*x - 2*y + 1
    add t2, t2, t3      # d += 2*x - 2*y + 1
    j bresenham_loop
    
d_negative:
    # d < 0
    slli t3, t0, 1      # 2*x
    addi t3, t3, 1      # 2*x + 1
    add t2, t2, t3      # d += 2*x + 1
    j bresenham_loop
    
next_thickness:
    addi s6, s6, 1      # thickness_counter++
    j thickness_loop
    
circle_done:
    lw a0, 36(sp)
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 40
    jr ra

# Ve mot pixel tai toa do (a0, a1)
draw_pixel:
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    # Kiem tra bien
    blt a0, zero, pixel_out_of_bounds
    blt a1, zero, pixel_out_of_bounds
    li t0, SCREEN_WIDTH
    bge a0, t0, pixel_out_of_bounds
    li t0, SCREEN_HEIGHT
    bge a1, t0, pixel_out_of_bounds
    
    # Tinh dia chi pixel
    li t0, MONITOR_SCREEN
    li t1, SCREEN_WIDTH
    slli t1, t1, 2      # t1 = SCREEN_WIDTH * 4
    mul t1, a1, t1      # t1 = y * SCREEN_WIDTH * 4
    add t0, t0, t1      # t0 = base_address + y_offset
    slli t1, a0, 2      # t1 = x * 4
    add t0, t0, t1      # t0 = pixel_address
    
    # Ve pixel
    sw s0, 0(t0)
    
pixel_out_of_bounds:
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 8
    jr ra

handle_key_input:
    li t0, KEYBOARD_STATUS
    lw t2, 0(t0)
    beqz t2, no_key
    
    li t0, KEYBOARD_DATA
    lw t3, 0(t0)
    sw zero, 0(t0)
    
    # Kiem tra phim di chuyen
    li t4, 119              # 'w'
    beq t3, t4, set_up
    li t4, 87               # 'W'
    beq t3, t4, set_up
    
    li t4, 115              # 's'
    beq t3, t4, set_down
    li t4, 83               # 'S'
    beq t3, t4, set_down
    
    li t4, 97               # 'a'
    beq t3, t4, set_left
    li t4, 65               # 'A'
    beq t3, t4, set_left
    
    li t4, 100              # 'd'
    beq t3, t4, set_right
    li t4, 68               # 'D'
    beq t3, t4, set_right
    
    li t4, 32               # Space
    beq t3, t4, set_stop
    
    # Kiem tra phim toc ?o
    li t4, 122              # 'z'
    beq t3, t4, increase_speed
    li t4, 90               # 'Z'
    beq t3, t4, increase_speed
    
    li t4, 120              # 'x'
    beq t3, t4, decrease_speed
    li t4, 88               # 'X'
    beq t3, t4, decrease_speed
    
    # Kiem tra phim thay doi kich thuoc bong
    li t4, 113              # 'q' - tang kich thuoc
    beq t3, t4, increase_radius
    li t4, 81               # 'Q'
    beq t3, t4, increase_radius
    
    li t4, 101              # 'e' - giam kich thuoc
    beq t3, t4, decrease_radius
    li t4, 69               # 'E'
    beq t3, t4, decrease_radius
    
    # Kiem tra phim thay doi do day vien
    li t4, 114              # 'r' - tang do day vien
    beq t3, t4, increase_thickness
    li t4, 82               # 'R'
    beq t3, t4, increase_thickness
    
    li t4, 116              # 't' - giam do day vien
    beq t3, t4, decrease_thickness
    li t4, 84               # 'T'
    beq t3, t4, decrease_thickness
    
    j no_key

set_up:
    li t5, 1
    j save_dir
    
set_down:
    li t5, 2
    j save_dir
    
set_left:
    li t5, 3
    j save_dir
    
set_right:
    li t5, 4
    j save_dir
    
set_stop:
    li t5, 0
    j save_dir

increase_speed:
    la t0, speed
    lw t1, 0(t0)
    li t2, 10
    bge t1, t2, adjust_delay
    addi t1, t1, 1
    sw t1, 0(t0)
    j adjust_delay

decrease_speed:
    la t0, speed
    lw t1, 0(t0)
    li t2, 1
    ble t1, t2, adjust_delay
    addi t1, t1, -1
    sw t1, 0(t0)
    j adjust_delay

increase_radius:
    # Xoa bong cu truoc
    li a0, BLACK
    jal draw_thick_circle
    
    la t0, ball_radius
    lw t1, 0(t0)
    li t2, 100              # Gioi han toi da
    bge t1, t2, skip_increase_radius
    addi t1, t1, 3
    sw t1, 0(t0)
    
skip_increase_radius:
    # Tiep tuc huong chuyen dong va nhay ve draw_initial_ball
    la t0, dir
    j main_loop    # Nhay ve ve bong ban dau

decrease_radius:
    # Xoa bong cu truoc
    li a0, BLACK
    jal draw_thick_circle
    
    la t0, ball_radius
    lw t1, 0(t0)
    li t2, 8                # Gioi han toi thieu
    ble t1, t2, skip_decrease_radius
    addi t1, t1, -3
    sw t1, 0(t0)
    
skip_decrease_radius:
    # Tiep tuc huong chuyen dong va nhay ve draw_initial_ball
    la t0, dir
    j main_loop    # Nhay ve ve bong ban dau

increase_thickness:
    # Xoa bong cu truoc
    li a0, BLACK
    jal draw_thick_circle
    
    la t0, border_thickness
    lw t1, 0(t0)
    li t2, 8                # Gioi han toi da
    bge t1, t2, skip_increase_thickness
    addi t1, t1, 1
    sw t1, 0(t0)
    
skip_increase_thickness:
    # Tiep tuc huong chuyen dong va nhay ve draw_initial_ball
    la t0, dir
    j main_loop    # Nhay ve ve bong ban dau

decrease_thickness:
    # Xoa bong cu truoc
    li a0, BLACK
    jal draw_thick_circle
    
    la t0, border_thickness
    lw t1, 0(t0)
    li t2, 1                # Gioi han toi thieu
    ble t1, t2, skip_decrease_thickness
    addi t1, t1, -1
    sw t1, 0(t0)
    
skip_decrease_thickness:
    # Tiep tuc huong chuyen dong va nhay ve draw_initial_ball
    la t0, dir
    j main_loop    # Nhay ve ve bong ban dau

adjust_delay: #dieu chinh toc do
    la t0, speed
    lw t1, 0(t0)
    
    li t2, 70
    li t3, 5
    mul t4, t1, t3
    sub t2, t2, t4
    
    li t5, 10
    blt t2, t5, min_delay
    j save_delay
    
min_delay: #toc do toi thieu
    li t2, 10
    
save_delay: #luu toc do
    la t0, delay_time
    sw t2, 0(t0)
    j no_key

save_dir: #luu huong
    la t6, dir
    sw t5, 0(t6)
    jr ra

no_key:
    jr ra
