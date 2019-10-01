# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'MultiDOE'
copyright = '2019, Luc LAURENT'
author = 'Luc LAURENT'

# The full version, including alpha/beta/rc tags
release = 'v3.3'

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['sphinx.ext.viewcode',
                'sphinx.ext.autodoc',
                'sphinx.ext.autosummary',
                'sphinxcontrib.matlab',
                'sphinx.ext.coverage',
                'sphinx.ext.napoleon']

primary_domain = 'mat'

autodoc_default_options = {'members': True,
                        'show-inheritance': True,
                        'undoc-members': True,
                        'ignore-module-all': True}
autoclass_content = 'both'

mathjax_path = 'http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default'

# The suffix of source filenames.
source_suffix = '.rst'

# The encoding of source files.
#source_encoding = 'utf-8'

# The master toctree document.
master_doc = 'index'

# autosummary_generate = True
#
# sys.path.insert(0, os.path.abspath('../src/'))
# sys.path.insert(0, os.path.abspath('../src/crit'))
this_dir = os.path.dirname(os.path.abspath(__file__))
matlab_src_dir = os.path.abspath(os.path.join(this_dir, '../..'))

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'classic'

# # Add any paths that contain custom static files (such as style sheets) here,
# # relative to this directory. They are copied after the builtin static files,
# # so a file named "default.css" will overwrite the builtin "default.css".
# # html_static_path = ['_static']

# # matlab source code
# matlab_src_dir = os.path.abspath(os.path.join('../..','../../MultiDOE'))

# primary_domain = 'mat'