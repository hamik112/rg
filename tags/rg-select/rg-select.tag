<rg-select>

	<input type="text"
				 name="selectfield"
				 class="field"
				 value="{ fieldText }"
				 placeholder="{ opts.select.placeholder }"
				 onkeydown="{ handleKeys }"
				 onclick="{ toggle }"
				 readonly>

	<ul class="menu menu--high" if="{ opts.select.isvisible }">
		<li each="{ opts.select.options }"
		     onclick="{ parent.select }"
				 class="menu__item { 'menu__item--active': selected, 'menu__item--disabled': disabled, 'menu__item--hover': active }">
			{ text }
		</li>
	</ul>

	<script>
		/* istanbul ignore next */
		if (!opts.select) opts.select = { options: [] }

		const handleClickOutside = e => {
			if (!this.root.contains(e.target)) this.close()
			this.update()
		}

		this.handleKeys = e => {
			if ([13, 38, 40].indexOf(e.keyCode) > -1 && !opts.select.isvisible) {
				e.preventDefault()
				this.open()
				return true
			}
			if (!opts.select.isvisible) this.open()
			var length = opts.select.options.length
			if (length > 0 && [13, 38, 40].indexOf(e.keyCode) > -1) {
				e.preventDefault()
					// Get the currently selected item
				var activeIndex = null
				for (let i = 0; i < length; i++) {
					let item = opts.select.options[i]
					if (item.active) {
						activeIndex = i
						break
					}
				}

				// We're leaving this item
				if (activeIndex != null) opts.select.options[activeIndex].active = false

				if (e.keyCode == 38) {
					// Move the active state to the next item lower down the index
					if (activeIndex == null || activeIndex == 0)
						opts.select.options[length - 1].active = true
					else
						opts.select.options[activeIndex - 1].active = true
				} else if (e.keyCode == 40) {
					// Move the active state to the next item higher up the index
					if (activeIndex == null || activeIndex == length - 1)
						opts.select.options[0].active = true
					else
						opts.select.options[activeIndex + 1].active = true
				} else if (e.keyCode == 13 && activeIndex != null) {
					this.select({
						item: opts.select.options[activeIndex]
					})
				}
			}
			return true
		};

		this.open = () => {
			opts.select.isvisible = true
			this.trigger('open')
		}

		this.close = () => {
			if (opts.select.isvisible) {
				opts.select.isvisible = false
				this.trigger('close')
			}
		}

		this.toggle = () => {
			if (opts.select.isvisible) this.close()
			else this.open()
		}

		this.select = e => {
			opts.select.options.forEach(i => i.selected = false)
			e.item.selected = true
			opts.select.isvisible = false
			this.trigger('select', e.item)
		}

		this.on('mount', () => {
			document.addEventListener('click', handleClickOutside)
			this.update()
		})

		this.on('update', () => {
			for (let i = 0; i < opts.select.options.length; i++) {
				let item = opts.select.options[i]
				if (item.selected) {
					this.selectfield.value = item.text
					break
				}
			}
			positionDropdown()
		})

		this.on('unmount', () => {
			document.removeEventListener('click', handleClickOutside)
		})

		function getWindowDimensions() {
			var w = window,
			d = document,
			e = d.documentElement,
			g = d.getElementsByTagName('body')[0],
			x = w.innerWidth || e.clientWidth || g.clientWidth,
			y = w.innerHeight || e.clientHeight || g.clientHeight;
			return { width: x, height: y }
		}

		const positionDropdown = () => {
			const w = getWindowDimensions()
			const m = this.root.querySelector('.menu')
			if (!m) return
			if (!opts.select.isvisible) {
				// Reset position
				m.style.marginTop = ''
				m.style.marginLeft = ''
				return
			}
			const pos = m.getBoundingClientRect()
			if (w.width < pos.left + pos.width) {
				// menu is off the right hand of the page
				m.style.marginLeft = (w.width - (pos.left + pos.width) - 20) + 'px'
			}
			if (pos.left < 0) {
				// menu is off the right hand of the page
				m.style.marginLeft = '20px'
			}
			if (w.height < pos.top + pos.height) {
				// Popup is off the bottom of the page
				m.style.marginTop = (w.height - (pos.top + pos.height) - 20) + 'px'
			}
		}

	</script>

	<style scoped>
		.menu {
			position: absolute;
		}

	</style>

</rg-select>
