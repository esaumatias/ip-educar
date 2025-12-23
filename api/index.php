<?php

/**
 * Vercel Serverless Function Wrapper for Laravel
 * This file is executed by Vercel's PHP runtime
 */

// Change to the project root directory
chdir(__DIR__ . '/..');

// Check if vendor exists
$vendorPath = __DIR__ . '/../vendor/autoload.php';
if (!file_exists($vendorPath)) {
    http_response_code(500);
    die('Error: Composer dependencies not found. Please ensure vendor directory is included in deployment.');
}

// Load the Laravel application
require __DIR__ . '/../public/index.php';

