<?php

/**
 * Vercel Serverless Function Wrapper for Laravel
 * This file is executed by Vercel's PHP runtime
 */

// Change to the project root directory
chdir(__DIR__ . '/..');

// Load the Laravel application
require __DIR__ . '/../public/index.php';

