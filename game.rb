#!/bin/env ruby
# encoding: utf-8

require 'colorize'
require 'debugger'
require 'board.rb'
require 'player.rb'
require 'piece.rb'


class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @players = []
    @kills = true
    start
  end 
   
  def display
    @board.display
  end
  
  def start 
    intro_setup
    play
  end
  
  def intro_setup
    puts ">Welcome to Checkers!"
    print ">What is the name of Player One?\n>"
    @players << Player.new(gets.chomp, :w)
    puts ">#{@players[0].name} will play the white side!"
    print ">What is the name of Player Two?\n>"
    @players << Player.new(gets.chomp, :b)
    puts ">#{@players[1].name} will play the black side!"
    puts ">Prepare for battle!"
    board.display
  end
  
  def play
    player = 0
    until @board.won?
      puts "Player #{player+1	}'s turn!"
      current_player = @players[player]
      get_and_make_move(current_player)
      player = player == 0 ? 1 : 0
      @board.kill_pos = nil
    end
    winner = @board.winner?
    if winner == :w
      puts ">#{@players[0].name} has won the game! The light side prevails!"
    elsif winner == :b
      puts ">#{@players[1].name} has realised the true power of the dark side!"
    else
      "Danger, Danger Will Robinson!"
    end
  end
  
  def get_and_make_move(player)
    start = nil
    until board.get_piece(start) && board.get_piece(start).color == player.color
      puts ">Move a piece of your own color."
      start = get_move
    end
    #let player make another move with current piece, if a kill is made
    @board.kills = true
    until @board.kills == false
      if @board.kill_pos.nil?
        finish = get_dest_then_move(start)  
      else
        finish = get_dest_then_move(@board.kill_pos)
      end
      return if finish == 'pass'
    end
  end
  
  def get_move
    coords = [-1,-1]
    until @board.on_board?(coords) && @board.get_piece(coords)
      puts ">What piece would you like to move?(By Row and Column. EG 0 0)" 
      coords = gets.chomp.split(' ').map(&:to_i)
    end
    coords
  end
  
  def get_dest_then_move(coords)
    dest = [-1,-1]
    until move(coords, dest)
      puts ">Where would you like to move piece at #{coords[0]} #{coords[1]}? ('Pass' to skip)" 
      dest = gets.chomp
      return 'pass' if dest.downcase == 'pass'
      dest = dest.split(' ').map(&:to_i)       
    end
    @board.display
  end
  
  def move(start, finish)
    @board.move_piece(start, finish)
  end
end
